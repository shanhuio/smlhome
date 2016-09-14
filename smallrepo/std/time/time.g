struct Time {
    ts long.Long
}

func (t *Time) Print() {
    printUint(t.ts.Hi)
    printUint(t.ts.Lo)
}

func Now(t *Time) {
    var resp [8]byte
    n, err := vpc.Call(vpc.Clock, nil, resp[:])
    if err != 0 {
        panic()
    }
    if n != 8 {
        panic()
    }

    t.ts.Lo = binary.U32(resp[:4])
    t.ts.Hi = binary.U32(resp[4:])
}
