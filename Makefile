PHONY: app-container clean

CR_FLAGS=--release --static --no-debug
UID=`id -u`
GID=`id -g`
UNAME=`whoami`

.docker-built:
	docker build -t gopher-builder -f Dockerfile.build --build-arg UID=${UID} --build-arg GID=${GID} --build-arg UNAME=${UNAME} . && touch .docker-built

bin/example: .docker-built
	docker run --rm -v ${PWD}:/opt/gopher -it gopher-builder shards build ${CR_FLAGS}

app-container: bin/example
	strip bin/example && docker build -t gopher .
clean:
	rm -rf ./bin/ .docker-built
