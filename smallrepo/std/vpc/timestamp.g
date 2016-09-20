func Timestamp(nanos *long.Long) {
    var resp [8]byte
    n, err := Call(Clock, nil, resp[:])
    if err != 0 {
        panic()
    }
    if n != 8 {
        panic()
    }

    nanos.Lo = binary.U32(resp[:4])
    nanos.Hi = binary.U32(resp[4:])
}
