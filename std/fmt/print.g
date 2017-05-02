// Copyright 2017 The G Authors. All rights reserved.
// license that can be found in the LICENSE file.

// print.g includes functions write to standard output

// PrintChar writes a char to standard output
// printChar is a build-in function in g compiler
func PrintChar(c char) {
    printChar(c)
}

// PrintBytes writes a byte slice to standard output
func PrintBytes(bs []byte) {
    for i := 0; i < len(bs); i++ {
        PrintChar(char(bs[i]))
    }
}

// PrintStr writes a string to standard output
func PrintStr(s string) {
    for i := 0; i < len(s); i++ {
        PrintChar(s[i])
    }
}

// Println writes a line break
func Println() {
    PrintChar('\n')
}

// PrintBool writes a boolean variable to standard output 
func PrintBool(b bool) {
    if b {
        PrintStr("true")
    } else {
        PrintStr("false")
    }
}

// PrintInt writes an int to standard output
// G only allows numbers within the range of int32 (−2147483648 to 2147483647),
// thus [11]byte is enough to write any legal integer, including the minus sign
func PrintInt(i int) {
    var bs [11]byte
    var buf bytes.Buffer

    buf.Init(bs[:])
    FprintInt(&buf, i)
    PrintBytes(buf.Bytes())
}

// PrintUint writes an uint to standard output
func PrintUint(i uint) {
    var bs [10]byte
    var buf bytes.Buffer

    buf.Init(bs[:])
    FprintUint(&buf, i)
    PrintBytes(buf.Bytes())
}