// FprintBool writes a boolean variable to a bytes buffer.
func FprintBool(w *bytes.Buffer, b bool) {
    if b {
        w.WriteString("true")
    } else {
        w.WriteString("false")
    }
}

// FprintInt writes an int to a bytes buffer.
func FprintInt(w *bytes.Buffer, i int) {
    if i >= 0 {
        FprintUint(w, uint(i))
        return
    }

    w.WriteChar('-')
    FprintUint(w, uint(-i))
}

// FprintBool writes an uint to a bytes buffer.
func FprintUint(w *bytes.Buffer, i uint) {
    if i == 0 {
        w.WriteChar('0')
        return
    }

    // uint32 ranges from 0 to 4294967295, and requires 10 chars
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
