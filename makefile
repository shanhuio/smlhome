.PHONY: all fmt

all:
	sml -test=false

test:
	sml -test=true

fmt:
	gfmt
