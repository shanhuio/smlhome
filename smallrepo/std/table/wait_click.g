var buf [vpc.MaxLen]byte

func WaitClick(nanos *long.Long) (uint8, bool) {
    s, n, err := vpc.Poll(nanos, buf[:])
    if err == vpc.ErrTimeout {
        return 0, false
    }

    if err != 0 {
        printInt(err)
        panic()
    }

    if s == 5 && n >= 1 {
        return buf[0], true
    }

    printUint(s)
    panic()
    return 0, false
}
