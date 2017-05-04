[![BuildStatus](https://travis-ci.org/shanhuio/smlhome.png?branch=master)](https://travis-ci.org/shanhuio/smlhome)

# Small Home

This repository contains all code hosted on
[smallrepo](https://smallrepo.com), which consists of the G language
standard library and some example programs.

This repository allows a user to run G language code on smallrepo
locally using
[Small Virtual Machine](https://github.com/shanhuio/smlvm)

## Build

Install [Small Virtual Machine](https://github.com/shanhuio/smlvm):

```
$ go get -u shanhu.io/smlvm
```

To build all the G language code, run under the root of this
repository:

```
$ sml
```

Or simply type `make`. It will output the results to the folder `_`,
The binary images for packages that contains a `main()` function
resides in `_/bin`.

## Format

To format code, run `make fmt`, which will format all `.g` files.

## Run Tests

To run test, run `sml -test`, or simply `make test`. It will perform
all tests in all the packages, similar to `go test ./...` in Go
language.

## Run a image

After compiling, use `smlvm <binary>.bin` to run a particular binary.
For example:

```
$ smlvm _/bin/h8liu/helloworld.bin
```

The `smlvm` command only supports output to `stdout` for now.

--

Visit [smallrepo](https://smallrepo.com) for more information.
