var buf [vpc.MaxLen]byte

func HandleClick(buf []byte) (int, int, bool) {
    if len(buf) < 2 return 0, 0, false

    x := int(buf[0])
    y := int(buf[1])
    return x, y, true
}

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

    if s == 2 {
        return HandleClick(buf[:n])
    }

    printUint(s)
    panic()
    return 0, 0, false
}
