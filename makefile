.PHONY: all fmt

all:
	sml

fmt:
	gfmt `find . -name *.g`

down:
	smlclient -host="http://localhost:3356" -space="h8liu:322e43792e48" -out="std.zip"
	rm -r smallrepo/std
	unzip -d smallrepo/std std.zip
	rm std.zip
