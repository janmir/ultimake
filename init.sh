#!/bin/bash
#$1 ...$n

#check if command line args exists
if [ "$#" -gt 0 ]
then
echo "Set-up $1"
if [ "$1" = "electron-grpc" ]
then
#Electron gRPC
cat > package.json <<EOL
{
  "name": "electron-grpc-boiler",
  "version": "1.0.0",
  "description": "UI written in electron+gRPC.",
  "main": "electron.js",
  "scripts": {
    "start": "electron . -debug",
    "dev": "electron-webpack dev",
    "compile": "electron-webpack",
    "watch": "webpack --watch",
    "build": "webpack",
    "pack": "webpack -p"
  },
  "repository": {
    "type": "git",
    "url": "..."
  },
  "keywords": [
    "hyperapp",
    "electron",
    "gRPC"
  ],
  "author": "janmir",
  "license": "MIT",
  "devDependencies": {
    "ajv": "^6.5.2",
    "babel-core": "^6.26.3",
    "babel-loader": "^7.1.5",
    "babel-plugin-transform-react-jsx": "^6.24.1",
    "babel-preset-env": "^1.7.0",
    "css-loader": "^1.0.0",
    "electron": "^2.0.5",
    "electron-builder": "^20.26.0",
    "electron-webpack": "^2.1.2",
    "extract-text-webpack-plugin": "^3.0.2",
    "file-loader": "^1.1.11",
    "style-loader": "^0.21.0",
    "svg-inline-loader": "^0.8.0",
    "url-loader": "^1.0.1",
    "webpack": "^4.15.0",
    "webpack-cli": "^3.1.0"
  },
  "dependencies": {
    "google-protobuf": "^3.6.0",
    "grpc": "^1.13.1",
    "grpc-tools": "^1.6.6",
    "hyperapp": "^1.2.8"
  }
}
EOL

cat > electron.js <<EOL
const {app, BrowserWindow} = require('electron')

console.log("Main process.")

const grpc = require('grpc')
const messages = require("./grpc_pb")
const services = require("./grpc_grpc_pb")

/**Server
const gRPCServer = {
  server: null,
  host: "localhost:5005",
  getServer: ()=>{
    var server = new grpc.Server();
    server.addService(services.RPCService, {
      connect: (call)=>{
          call.on('data', function(package) {
            console.log(package.getData())
            setTimeout(()=>{
              var req = new messages.Package();
              req.setData("Hellooowww pows");
              call.write(req)
            }, 1000)
          });
          call.on('end', function() {
            console.log("Ending...")
          });        
      }
    });
    return server;
  },
  startServer: ()=>{
    gRPCServer.server = gRPCServer.getServer()
    gRPCServer.server.bind(gRPCServer.host, 
      grpc.ServerCredentials.createInsecure());
    gRPCServer.server.start();
  }
}
*/

/** gRPC Client
const gRPCClient = {
  client: null,
  host: "localhost:5005",
  getClient: ()=>{
    var client = new services.RPCClient('0.0.0.0:5000', 
      grpc.credentials.createInsecure());
    return client
  },
  connectClient: ()=>{
    var client = gRPCClient.getClient()
    gRPCClient.client = client.connect();
    gRPCClient.client.on('data', function(pack) {
      console.log("On-Receive-Data:")
      console.log(pack.getData())
    });
    
    gRPCClient.client.on('end', function(pack) {
      console.log("On-Exit:")
      console.log(pack)
    });
  },
  sendEnd: ()=>{
      console.log("On-Send-Data")
      var request = new messages.Package();
      request.setData("Hellooowww pows");
      gRPCClient.client.write(request);
      gRPCClient.client.end();
  }
}
*/

function createWindow () {
  //Create the browser window.
  win = new BrowserWindow({width: 800, height: 600})

  //Load the index.html of the app.
  win.loadFile('index.html')

  //Open Development tool
  win.webContents.openDevTools()
  
  console.log("Starting grpc server.")
  gRPCServer.startServer()
  console.log("Started.")
}

app.on('ready', createWindow)

EOL

cat > grpc.proto <<EOL
syntax = "proto3";
package main;
service RPC{
    rpc Connect(stream Package) returns (stream Package){}
}

message Package{
    string realm = 1;
    string data = 2;
}
EOL

elif [ "$1" = "electron" ]
then
#Electron
cat > package.json <<EOL
{
  "name": "electron-boiler-ui",
  "version": "1.0.0",
  "description": "UI written in electron.",
  "main": "electron.js",
  "scripts": {
    "start": "electron . -debug",
    "dev": "electron-webpack dev",
    "compile": "electron-webpack",
    "watch": "webpack --watch",
    "build": "webpack",
    "pack": "webpack -p"
  },
  "repository": {
    "type": "git",
    "url": "..."
  },
  "keywords": [
    "hyperapp",
    "electron"
  ],
  "author": "janmir",
  "license": "MIT",
  "devDependencies": {
    "ajv": "^6.5.2",
    "babel-core": "^6.26.3",
    "babel-loader": "^7.1.5",
    "babel-plugin-transform-react-jsx": "^6.24.1",
    "babel-preset-env": "^1.7.0",
    "css-loader": "^1.0.0",
    "electron": "^2.0.5",
    "electron-builder": "^20.26.0",
    "electron-webpack": "^2.1.2",
    "extract-text-webpack-plugin": "^3.0.2",
    "file-loader": "^1.1.11",
    "style-loader": "^0.21.0",
    "svg-inline-loader": "^0.8.0",
    "url-loader": "^1.0.1",
    "webpack": "^4.15.0",
    "webpack-cli": "^3.1.0"
  },
  "dependencies": {
    "hyperapp": "^1.2.8"
  }
}
EOL

cat > electron.js <<EOL
const {app, BrowserWindow} = require('electron')

console.log("Main process.")

function createWindow () {
  //Create the browser window.
  win = new BrowserWindow({width: 800, height: 600})

  //Load the index.html of the app.
  win.loadFile('index.html')

  //Open Development tool
  win.webContents.openDevTools()
  
  console.log("Started.")
}

app.on('ready', createWindow)
EOL

else

#Web
cat > package.json <<EOL
{
  "name": "hyperapp-web-ui",
  "version": "1.0.0",
  "description": "HyperApp implemented web application.",
  "scripts": {
    "start" : "webpack-dev-server --mode development",
    "watch": "webpack --watch",
    "build": "webpack",
    "pack": "webpack -p"
  },
  "repository": {
    "type": "git",
    "url": "..."
  },
  "keywords": [
    "hyperapp",
    "tgif"
  ],
  "author": "janmir",
  "license": "MIT",
  "devDependencies": {
    "ajv": "^6.5.2",
    "babel-core": "^6.26.3",
    "babel-loader": "^7.1.5",
    "babel-plugin-transform-react-jsx": "^6.24.1",
    "babel-preset-env": "^1.7.0",
    "css-loader": "^1.0.0",
    "extract-text-webpack-plugin": "^3.0.2",
    "file-loader": "^1.1.11",
    "style-loader": "^0.21.0",
    "svg-inline-loader": "^0.8.0",
    "url-loader": "^1.0.1",
    "webpack": "^4.15.0",
    "webpack-cli": "^3.1.0"
  },
  "dependencies": {
    "hyperapp": "^1.2.8"
  }
}
EOL

fi
else
echo "Generic Set-up"

cat > README.md <<EOL
# Hi! 🚀
EOL

cat > package.json <<EOL
{
  "name": "electron-temp-package",
  "version": "1.0.0",
  "description": "UI written in electron.",
  "main": "electron.js",
  "scripts": {
    "start": "electron . -debug",
    "dev": "electron-webpack dev",
    "compile": "electron-webpack",
    "watch": "webpack --watch",
    "build": "webpack",
    "pack": "webpack -p"
  },
  "repository": {
    "type": "git",
    "url": "..."
  },
  "keywords": [
    "hyperapp",
    "electron"
  ],
  "author": "janmir",
  "license": "MIT",
  "devDependencies": {
  },
  "dependencies": {
  }
}
EOL

cat > webpack.config.js <<EOL
const path = require('path');

module.exports = {
  mode: 'none',
  entry: './index.js',
  output: {
    filename: 'app.js',
    path: __dirname
  },
  module: {
    rules: [
      { test: /\.js$/, exclude: /node_modules/, loader: "babel-loader" },
      { test: /\.css$/, use: [
         'style-loader', 'css-loader' 
      ]},
      {
        test: /\.(png|jpg|gif|svg|eot|ttf|woff|woff2)$/,
        loader: 'url-loader',
        options: {
          limit: 10000
        }
      },
      {
        test: /\.svg$/,
        loader: 'svg-inline-loader',
        options:{
          removeTags: true,
          removingTags:[
            "desc"
          ]
        }
      }
    ]
  },
  watchOptions: {
    poll: true
  },
  //externals: {
  //  grpc: 'grpc'
  //},
  //target: "electron-main"
};
EOL

cat > .babelrc <<EOL
{
  "presets": ["env"],
  "plugins": [["transform-react-jsx", { "pragma": "h" }]]
}
EOL

cat > index.js <<EOL
import { h, app } from "hyperapp"
import "./style.css"

//State-------------------------------------------------------------------------------
const state = {
    
}

//Action------------------------------------------------------------------------------
const actions = {
    
}

//Component---------------------------------------------------------------------------
const Comp = () => (
  <div></div>
)

//View--------------------------------------------------------------------------------
const view = (state, actions) => (
    <div>Hello World!!</div>
)

const hype = app(state, actions, view, document.body)
EOL

cat > index.html <<EOL
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Hello World!</title>
    </head>
    <body>
    </body>
    <noscript>Hi please js it.</noscript>
    <script src="app.js"></script>
</html>
EOL

cat > style.css <<EOL
body{
  margin: 0;
  padding: 0;
}
EOL

fi