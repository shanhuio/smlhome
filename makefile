.PHONY: all fmt

all:
	sml

fmt:
	gfmt `find . -name *.g`

localdown:
	smlclient -host="http://localhost:3356" -space="h8liu:322e43792e48" -out="std.zip"
	rm -r smallrepo/std
	unzip -d smallrepo/std std.zip
	rm std.zip

localup:
	-rm std.zip
	cd smallrepo/std && zip -r ../../std.zip .
	smlclient -host="http://localhost:3356" -space="h8liu:322e43792e48" -in="std.zip"
	rm std.zip
