struct BoxArray {
    boxes [nbox]*Box
    n int
}

func (a *BoxArray) Clear() {
    a.n = 0
}

func (a *BoxArray) Append(b *Box) {
    a.boxes[a.n] = b
    a.n++
}

func (a *BoxArray) get(i int) *Box {
    return a.boxes[i]
}

func (a *BoxArray) Size() int {
    return a.n
}
