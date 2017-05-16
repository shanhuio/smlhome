var buf [vpc.MaxLen]byte

const portTerminal = 1004

func HandleClick(p []byte) (int, int, bool) {
    if len(p) < vpc.PacketHeaderLen return 0, 0, false
    h := p[:vpc.PacketHeaderLen]
    destPort := binary.U16B(h[12:14])
    payload := p[vpc.PacketHeaderLen:]

    if destPort != portTerminal return 0, 0, false
    if len(payload) < 2 return 0, 0, false

    x := int(payload[0])
    y := int(payload[1])
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

    if s == 0 {
        return HandleClick(buf[:n])
    }

    printUint(s)
    panic()
    return 0, 0, false
}
