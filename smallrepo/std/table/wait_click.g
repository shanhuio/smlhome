var buf [vpc.MaxLen]byte

func HandleClick(buf []byte) (uint8, uint8) {
    if len(buf) < 2 return 0, 0
    return buf[0], buf[1]
}

const (
    OnTable = 0
    OnCard = 1
    OnButton = 2
)

func WaitClick(nanos *long.Long) (uint8, uint8, bool) {
    s, n, err := vpc.Poll(nanos, buf[:])
    if err == vpc.ErrTimeout return 0, 0, false

    if err != 0 {
        printInt(err)
        panic()
    }

    if s == 5 {
        what, pos := HandleClick(buf[:n])
        return what, pos, true
    }

    printUint(s)
    panic()
    return 0, 0, false
}
