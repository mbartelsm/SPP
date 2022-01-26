build:
	@echo BUILDING
	@echo ======================================
	mkdir -p ./ebin/
	erl -make

run: export ERL_LEVEL = error
run: build
	unset ERL_LEVEL
	@echo
	@echo EXECUTING
	@echo ======================================
	erl -noinput -noshell -pa ./ebin/ -s main main

# See: https://www.gnu.org/software/make/manual/html_node/Target_002dspecific.html
debug: export ERL_LEVEL = debug
debug: build
	@echo
	@echo EXECUTING DEBUG
	@echo ======================================
	erl -pa ./ebin/ -s main main

clean:
	rm -fr ./ebin/
	rm -fr erl_crash.dump

all: build
