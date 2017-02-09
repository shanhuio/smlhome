var msgBuf [1300]byte

func call(buf []byte) {
    _, err := vpc.Call(vpc.Table, buf, nil)
    if err != 0 {
        printInt(err)
        panic()
    }
}

const (
    commit = 0

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

    picShow = 12
    picHide = 13
    picPosition = 14

    divUpdate = 15

    boxClassUpdate = 16
    boxUpdate = 17
    boxShow = 18
)

func actCommit() {
    buf := msgBuf[:1]
    buf[0] = 0
    call(buf)
}

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

func actNums(action uint8, n1, n2 int) {
    buf := msgBuf[:10]
    buf[0] = action
    buf[1] = 0
    binary.PutI32(buf[2:6], n1)
    binary.PutI32(buf[6:10], n2)
    call(buf)
}

func actString(action, pos uint8, s string) {
    n := len(s)
    end := n + 3
    if end > len(msgBuf) {
        end = len(msgBuf)
    }
    buf := msgBuf[:end]
    buf[0] = action
    buf[1] = pos
    buf[2] = uint8(n)
    for i := 3; i < end; i++ {
        buf[i] = byte(s[i - 3])
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
