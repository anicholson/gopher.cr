PHONY: app-container clean check test deps crytic

CR_FLAGS="--release --static --no-debug -Dtrace"
PUBLIC_PORT=9000

app-container:
	docker build -t gopher --build-arg CRFLAGS=${CR_FLAGS} --build-arg PUBLIC_PORT=${PUBLIC_PORT} .

clean:
	rm -rf ./bin/ 

check:
	crystal build --no-codegen src/**/*.cr

deps:
	shards install

test: deps
	crystal spec -- -p 3

crytic: deps
	bin/crytic --preamble ""
