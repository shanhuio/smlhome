var msgBuf [512]byte

func call(buf []byte) {
    _, err := vpc.Call(vpc.Table, buf, nil)
    if err != 0 {
        printInt(err)
        panic()
    }
}

const (
    cardShow = 1
    cardShowFront = 2
    cardShowBack = 3
    cardHide = 4
    cardHideFront = 5
    cardHideBack = 6
    cardFace = 7

    labelText = 8

    buttonShow = 9
    buttonHide = 10
    buttonText = 11
)

func act(action, pos uint8) {
    actChar(action, pos, char(0))
}

func actChar(action, pos uint8, face char) {
    buf := msgBuf[:4]
    buf[0] = action
    buf[1] = pos
    buf[2] = uint8(face)
    call(buf)
}

func actString(action, pos uint8, s string) {
    n := len(s)
    buf := msgBuf[:n + 3]
    buf[0] = action
    buf[1] = pos
    buf[2] = uint8(n)
    for i := 0; i < n; i++ {
        buf[3 + i] = byte(s[i])
    }
    call(buf)
}

func actBytes(action, pos uint8, bs []byte) {
    n := len(bs)
    buf := msgBuf[:n + 3]
    buf[0] = action
    buf[1] = pos
    buf[2] = uint8(n)
    for i := 0; i < n; i++ {
        buf[3 + i] = bs[i]
    }
    call(buf)
}
