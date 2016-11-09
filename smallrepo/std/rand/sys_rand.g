// SysRand reads a random uint32 from the system's random source.
func SysRand() uint32 {
    var resp [4]byte
    n, err := vpc.Call(vpc.Rand, nil, resp[:])
    if err != 0 {
        panic()
    }
    if n != 4 {
        panic()
    }
    return binary.U32(resp[:])
}

func TestSysRand() {
    a := SysRand()
    b := SysRand()
    assert(a != b)
}
