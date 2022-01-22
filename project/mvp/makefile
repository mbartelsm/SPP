build:
	@echo BUILDING
	@echo ======================================
	mkdir -p ./ebin/
	erl -make

run: build
	unset ERL_LEVEL=debug
	@echo
	@echo EXECUTING
	@echo ======================================
	erl -noinput -noshell -pa ./ebin/ -s main main

debug: build
	export ERL_LEVEL=debug
	@echo
	@echo EXECUTING DEBUG
	@echo ======================================
	erl -noinput -noshell -pa ./ebin/ -s main main
	unset ERL_LEVEL
