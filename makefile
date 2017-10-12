.PHONY: all fmt

all:
	smlg -test=false

test:
	smlg -test=true

fmt:
	gfmt
