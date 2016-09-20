var buf [vpc.MaxLen]byte

// WaitClick sleeps until a click on the screen occurs.
func WaitClick(nanos *long.Long) (int, int, bool) {
    s, n, err := vpc.Poll(nanos, buf[:])
    if err == vpc.ErrTimeout {
        return 0, 0, false
    }

    if err != 0 {
        printInt(err)
        panic()
    }

    if s == 2 && n >= 2 {
        x := int(buf[0])
        y := int(buf[1])
        return x, y, true
    }

    printUint(s)
    panic()
    return 0, 0, false
}
