var msgBuf [512]byte

func call(buf []byte) {
    _, err := vpc.Call(vpc.Table, buf, nil)
    if err != 0 {
        printInt(err)
        panic()
    }
}

func act(action, pos uint8, face char) {
    buf := msgBuf[:4]
    buf[0] = action
    buf[1] = pos
    buf[2] = uint8(face)
    call(buf)
}

const (
    Show = 1
    ShowFront = 2
    ShowBack = 3
    Hide = 4
    HideFront = 5
    HideBack = 6

    setFace = 7
    setText = 8
)

func Act(pos, action uint8) {
    act(action, pos, char(0))
}

func SetFace(pos uint8, c char) {
    act(setFace, pos, c)
}

func SetText(pos uint8, s string) {
    n := len(s)
    buf := msgBuf[:n + 3]
    buf[0] = setText
    buf[1] = pos
    buf[2] = uint8(n)
    for i := 0; i < n; i++ {
        buf[3 + i] = byte(s[i])
    }

    call(buf)
}

func SetTextBytes(pos uint8, bs []byte) {
    n := len(bs)
    buf := msgBuf[:n + 3]
    buf[0] = setText
    buf[1] = pos
    buf[2] = uint8(n)
    for i := 0; i < n; i++ {
        buf[3 + i] = bs[i]
    }

    call(buf)
}
