# original coffeescript Makefile from
# https://blog.jcoglan.com/2014/02/05/building-javascript-projects-with-make/

PATH  := node_modules/.bin:$(PATH)
SHELL := /bin/bash

source_files    := $(wildcard *.coffee)
build_files     := $(source_files:%.coffee=%.js)

.PHONY: all clean dev forever prod

all: $(build_files)

%.js: %.coffee
	coffee -co $(dir $@) $<

clean:
	rm -f *.js

dev:
	nodemon -e '.coffee' -x 'bash' server.sh

forever:
	./start-restart.sh

prod : | clean all forever
