all:
	@echo "\nRunning lua project...\n"
	lua src/project.lua
test:
	@echo "\nRunning tests...\n"

style:
	@echo "\nRunning stylua...\n"
	stylua .

lint:
	@echo "\nRunning luacheck\n"
	luacheck lua/*
	@echo "\nRunning stylua check...\n"
	@# stylua --check .

.PHONY: test lint style
