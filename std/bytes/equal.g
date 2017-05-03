// It is kind of weird to put this equal and buffer at the same package

// func Equal returns whether two bytes slices have the same value
func Equal(bs1, bs2 []byte) bool {
    n := len(bs1)
    if n != len(bs2) return false
    for i := 0; i < n; i++ {
        if bs1[i] != bs2[i] return false
    }
    return true
}
