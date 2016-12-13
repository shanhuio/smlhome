var (
    ieeeTable Table
)

func init() {
    ieeeTable.Init(IEEE)
}

func ChecksumIEEE(bs []byte) uint32 {
    return Checksum(&ieeeTable, bs)
}

func strBytes(s string) []byte {
    if len(s) == 0 return nil
    return make([]byte, len(s), uint(&s[0]))
}

func testIEEE(want uint32, s string) {
    bs := strBytes(s)
    got := ChecksumIEEE(bs)
    printUint(got)
    assert(got == want)
}

func TestIEEE() {
    testIEEE(0, "")
    testIEEE(0xe8b7be43, "a")
    testIEEE(0x9e83486d, "ab")
    testIEEE(0x352441c2, "abc")
    testIEEE(0x7d0a377f, "C is as portable as Stonehedge!!")
}
