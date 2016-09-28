.PHONY: all fmt

all:
	sml

fmt:
	gfmt `find . -name *.g`
