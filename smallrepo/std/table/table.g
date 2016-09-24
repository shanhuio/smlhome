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
    actionShow = 1
    actionShowFront = 2
    actionShowBack = 3
    actionHide = 4
    actionSetFace = 5
)

func Show(pos uint8) {
    act(actionShow, pos, char(0))
}

func Hide(pos uint8) {
    act(actionHide, pos, char(0))
}

func ShowFront(pos uint8) {
    act(actionShowFront, pos, char(0))
}

func ShowBack(pos uint8) {
    act(actionShowBack, pos, char(0))
}

func SetFace(pos uint8, c char) {
    act(actionSetFace, pos, c)
}
