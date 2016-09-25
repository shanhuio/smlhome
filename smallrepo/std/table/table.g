func act(action, pos uint8, face char) {
    var buf [4]byte
    buf[0] = action
    buf[1] = pos
    buf[2] = uint8(face)
    _, err := vpc.Call(vpc.Table, buf[:], nil)
    if err != 0 {
        printInt(err)
        panic()
    }
}

const (
    Show = 1
    ShowFront = 2
    ShowBack = 3
    Hide = 4
    HideFront = 5
    HideBack = 6
)

func Act(pos, action uint8) {
    act(action, pos, char(0))
}

func SetFace(pos uint8, c char) {
    const setFace = 7
    act(setFace, pos, c)
}
