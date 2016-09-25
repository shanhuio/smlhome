var buf [vpc.MaxLen]byte

func HandleClick(buf []byte) (uint8, bool) {
    if len(buf) < 1 return 0, false
    return buf[0], true
}

func WaitClick(nanos *long.Long) (uint8, bool) {
    s, n, err := vpc.Poll(nanos, buf[:])
    if err == vpc.ErrTimeout return 0, false

    if err != 0 {
        printInt(err)
        panic()
    }

    if s == 5 return HandleClick(buf[:n])

    printUint(s)
    panic()
    return 0, false
}
