// Equal checks if two byte slices are the same.
func Equal(bs1, bs2 []byte) bool {
    n := len(bs1)
    if n != len(bs2) return false
    for i := 0; i < n; i++ {
        if bs1[i] != bs2[i] return false
    }
    return true
}
