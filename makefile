all:
	npm start

webpack:
	npm run pack

build-electron:
	node ./node_modules/.bin/electron-builder

build-go-dev:
	go build -tags dev -race

build-go-release:
	go build -tags release

build-no-gui:
	go build -tags release -ldflags -H=windowsgui

############################################################################################
#                                Go Profiling Script                                       #
############################################################################################

mem-profile:
	go test -cover -bench . -benchtime 2s -benchmem -memprofile prof.mem

cpu-profile:
	go test -cover -bench . -benchtime 2s -benchmem -cpuprofile prof.cpu

cpu-pprof:
	go tool pprof prof.test prof.cpu

mem-pprof:
	go tool pprof -alloc_objects prof.test prof.mem

trace-to-pprof:
	#net, sync, syscall, sched
	go tool trace -pprof=syscall trace.out > syscal.pprof
	#go tool pprof -web syscal.pprof
	#go-torch -b syscal.pprof
	#open torch.svg

trace:
	#inline - import "runtime/pprof" | "runtime/trace"
	#inline - pprof.StartCPUProfile(os.Stdout) | trace.Start(os.Stdout)
	#inline - defer pprof.StopCPUProfile() | defer trace.Stop()
	#https://golang.org/cmd/trace/
	go test -bench . -trace trace.out

escape-analysis:
	go test -gcFlags '-m -m'

############################################################################################
#                                Initialization Script                                     #
############################################################################################

#Initialize Web Project---------------------------------------------------------------------
init-web: init-files install-webpack install-babel
	npm install hyperapp --save
	npm install --save-dev webpack-dev-server
	./init.sh web
	npm run build

#Initialize Electron Project----------------------------------------------------------------
init-electron: init-files install-webpack install-babel install-electron
	#https://github.com/louischatriot/nedb#persistence
	npm install hyperapp --save
	./init.sh electron
	npm run build

#Initialize Electron+gRPC Project-----------------------------------------------------------
init-electron-grpc: init-files install-webpack install-babel install-electron install-grpc
	npm install hyperapp --save
	./init.sh electron-grpc
	npm run build

init-files: #1
	chmod +x init.sh
	./init.sh

############################################################################################
#                                     Install Script                                       #
############################################################################################

install-grpc: #1
	npm install google-protobuf --save
	sudo npm install grpc --runtime=electron --target=2.0.4 --save
	sudo npm install --unsafe-perm  grpc-tools --save

install-electron:
	npm install electron@latest --save-dev
	npm install electron-webpack --save-dev
	npm install electron-builder --save-dev
	mkdir build

install-babel:
	npm install babel-core --save-dev
	npm install babel-loader --save-dev
	npm install babel-preset-env --save-dev
	npm install babel-plugin-transform-react-jsx --save-dev
	touch .babelrc

install-webpack:
	npm install --save-dev ajv@^6.0.0
	npm install --save-dev webpack@4.15.0
	npm install --save-dev webpack-cli
	npm install --save-dev extract-text-webpack-plugin
	npm install --save-dev css-loader style-loader url-loader file-loader
	npm install --save-dev svg-inline-loader
	touch webpack.config.js

#create the proto files
protoc:
	grpc_tools_node_protoc --js_out=import_style=commonjs,binary:. --grpc_out=. --plugin=protoc-gen-grpc=`which grpc_tools_node_protoc_plugin` grpc.proto

############################################################################################
#                                     Golang Serverless                                    #
############################################################################################

sls-init:
	sls create -t aws-go-dep -p service

sls-build:
	dep ensure
	env GOOS=linux go build -ldflags="-s -w" -o bin/service service/main.go

.PHONY: clean
sls-clean:
	rm -rf ./bin ./vendor Gopkg.lock

.PHONY: deploy
sls-deploy: clean build
	sls deploy --verbose