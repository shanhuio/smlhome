// PollClick polls the recent click on the screen.
func PollClick() (int, int, bool) {
    const offset = 4096 * 2 + 0x10
    pt := (*uint32)(uint32(offset))
    v := *pt
    if v & 0x1 == 0 return 0, 0, false

    *pt = 0
    line := (v >> 16) & 0xff
    col := (v >> 24) & 0xff
    return int(line), int(col), true
}

var buf [vpc.MaxLen]byte

// WaitClick sleeps until a click on the screen occurs.
func WaitClick() (int, int) {
    s, n, err := vpc.Poll(nil, buf[:])
    if err != 0 {
        printInt(err)
        panic()
    }

    if s == 2 {
        if n >= 2 {
            x := int(buf[0])
            y := int(buf[1])
            return x, y
        } else {
            printInt(n)
        }
    }

    printUint(s)
    panic()
    return 0, 0
}
