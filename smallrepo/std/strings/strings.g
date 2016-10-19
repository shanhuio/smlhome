func Equals(s1, s2 string) bool {
    n := len(s1)
    if n != len(s2) return false
    for i := 0; i < n; i++ {
        if s1[i] != s2[i] return false
    }
    return true
}
