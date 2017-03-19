const (
    clockTime = 0
    clockMono = 1
)

func callClock(s byte, nanos *long.Long) {
    var resp [8]byte
    var in [1]byte
    in[0] = s
    n, err := Call(Clock, in[:], resp[:])
    if err != 0 {
        panic()
    }
    if n != 8 {
        panic()
    }

    nanos.Lo = binary.U32(resp[:4])
    nanos.Hi = binary.U32(resp[4:])
}

func Timestamp(nanos *long.Long) {
    callClock(0, nanos)
}

func TimeElapsed(nanos *long.Long) {
    callClock(1, nanos)
}
