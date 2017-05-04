// PrintChar writes a char to standard output.
func PrintChar(c char) {
    // printChar is a build-in function in G compiler.
    printChar(c)
}

// PrintBytes writes a byte slice to standard output.
func PrintBytes(bs []byte) {
    for i := 0; i < len(bs); i++ {
        PrintChar(char(bs[i]))
    }
}

// PrintStr writes a string to standard output.
func PrintStr(s string) {
    for i := 0; i < len(s); i++ {
        PrintChar(s[i])
    }
}

// Println writes a line break.
func Println() {
    PrintChar('\n')
}

// PrintBool writes a boolean variable to standard output.
func PrintBool(b bool) {
    if b {
        PrintStr("true")
    } else {
        PrintStr("false")
    }
}

// PrintInt writes an int to standard output.
func PrintInt(i int) {
    // int32 ranges from −2147483648 to 2147483647, and requires 11 chars.
    var bs [11]byte
    var buf bytes.Buffer

    buf.Init(bs[:])
    FprintInt(&buf, i)
    PrintBytes(buf.Bytes())
}

// PrintUint writes an uint to standard output.
func PrintUint(i uint) {
    // uint32 ranges from 0 to 4294967295, and requires 10 chars
    var bs [10]byte
    var buf bytes.Buffer

    buf.Init(bs[:])
    FprintUint(&buf, i)
    PrintBytes(buf.Bytes())
}
