func Equals(s1, s2 string) bool {
    n := len(s1)
    if n != len(s2) return false
    for i := 0; i < n; i++ {
        if s1[i] != s2[i] return false
    }
    return true
}

func FromBytes(bs []byte) string {
    return make([]char, len(bs), (*char)(&bs[0]))
}
