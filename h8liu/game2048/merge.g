func reverse(line []*piece) {
    line[0], line[3] = line[3], line[0]
    line[1], line[2] = line[2], line[1]
}

func merge(line, bg []*piece, toEnd bool) bool {
    var buf [size]*piece
    n := 0

    if !toEnd {
        for i := 0; i < size; i++ {
            buf[i] = line[i]
        }
    } else {
        for i := 0; i < size; i++ {
            buf[i] = line[size - i - 1]
        }
    }

    for i := 0; i < size; i++ {
        bg[i] = nil
    }

    m := len(line)
    canMerge := false
    for i := 0; i < m; i++ {
        c := buf[i]
        if c == nil continue

        if canMerge && c.value == buf[n - 1].value {
            buf[n - 1].toDouble = true
            bg[n - 1] = c
            canMerge = false
            continue
        }

        canMerge = true
        buf[n] = c
        n++
    }

    for i := n; i < size; i++ {
        buf[i] = nil
    }

    if toEnd {
        reverse(buf[:])
        reverse(bg)
    }

    changed := false
    for i := 0; i < size; i++ {
        if line[i] != buf[i] {
            changed = true
        }
        line[i] = buf[i]
    }

    return changed
}
