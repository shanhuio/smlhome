func FprintInt(w *bytes.Buffer, i int) {
    if i >= 0 {
        FprintUint(w, uint(i))
        return
    }

    w.WriteChar('-')
    FprintUint(w, uint(-i))
}

func FprintUint(w *bytes.Buffer, i uint) {
    if i == 0 {
        w.WriteChar('0')
        return
    }

    var buf [10]char
    n := 0
    for i > 0 {
        buf[n] = char(i % 10) + '0'
        i /= 10
        n++
    }
    for n > 0 {
        n--
        w.WriteChar(buf[n])
    }
}
