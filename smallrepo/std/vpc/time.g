func TimeNow(t *time.Time) {
    var resp [8]byte
    n, err := Call(Clock, nil, resp[:])
    if err != 0 {
        panic()
    }
    if n != 8 {
        panic()
    }

    var u long.Long
    u.Lo = binary.U32(resp[:4])
    u.Hi = binary.U32(resp[4:])
    t.Set(&u)
}
