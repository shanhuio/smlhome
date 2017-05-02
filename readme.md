[![BuildStatus](https://travis-ci.org/shanhuio/smlhome.png?branch=master)](https://travis-ci.org/shanhuio/smlhome)

##Small home
Together with Small VM:https://github.com/shanhuio/smlvm
Small home provides an enviranment to run G language locally.
Small home includes the standard library and examples of G language code.

##Make and Run:
Make sure you have Small VM installed at your computer under [~/directory/?]

#Make
~/smlhome$ make
This command will compile all .g files under ~/smlhome directory.
The binaries for each packages are located at ~/smlhome/\_/bin/
#Format
~/smlhome$ make fmt
This command will fmt all .g files under ~/smlhome directory, similar to go fmt ./...
#Test
~/smlhome$ make test
This command will perform all test functions in .g files, similar to go test ./...
#Run
After compiling, use smlvm binary.e8 to run, e.g.:
~$ smlvm smlhome/\_/bin/h8liu/helloworld.e8

Now only we only suport std output under Small home,
visit http://smallrepo.com to explore more features!

Enjoy!
