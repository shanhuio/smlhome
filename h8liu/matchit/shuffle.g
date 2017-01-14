func shuffle(b []*block) {
    var posBuf [nblock]int
    n := 0
    for i := 0; i < nblock; i++ {
        if b[i].visible {
            posBuf[n] = i
            n++
        }
    }

    valids := posBuf[:n]

    n = len(valids)
    for i := 0; i < n - 1; i++ {
        step := rand.IntN(n - i)
        if step == 0 continue
        t := i + step
        i1 := valids[i]
        i2 := valids[t]
        valids[i], valids[t] = i2, i1
        b[i1], b[i2] = b[i2], b[i1]
    }
}
