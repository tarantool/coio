bootstrap: .rocks

.rocks: coio-scm-1.rockspec
	tarantoolctl rocks make ./coio-scm-1.rockspec
	tarantoolctl rocks install luatest 0.2.0
	tarantoolctl rocks install luacheck

.PHONY: lint
lint: bootstrap
	.rocks/bin/luacheck ./

.PHONY: test
test: bootstrap
	tarantoolctl rocks make
	.rocks/bin/luatest

.PHONY: clean
clean:
	rm -rf .rocks {.,coio}/*.{so,o}
