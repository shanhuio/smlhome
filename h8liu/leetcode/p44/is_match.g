func hasPrefix(input, pattern string) bool {
    if len(input) < len(pattern) return false
    for i := 0; i < len(pattern); i++ {
        if pattern[i] == '?' continue
        if input[i] == pattern[i] continue
        return false
    }
    return true
}

func find(input string, offset int, pattern string) int {
    // Might be able to optimize this witk KMP.
    for i := offset; i < len(input) - len(pattern); i++ {
        if hasPrefix(input[i:], pattern) return i
    }
    return len(input)
}

func findFirstNotStar(s string, offset int) int {
    for i := offset; i < len(s); i++ {
        if s[i] != '*' return i
    }
    return len(s)
}

func findFirstStar(s string, offset int) int {
    for i := offset; i < len(s); i++ {
        if s[i] == '*' return i
    }
    return len(s)
}

// IsMatch checks if input matches the pattern.
// ? is a single char wildcard, where * is a multi-char wildcard.
func IsMatch(input, pattern string) bool {
    pt := 0
    i := 0
    npattern := len(pattern)
    ninput := len(input)

    for {
        start := findFirstNotStar(pattern, pt)
        if start >= npattern return true
        end := findFirstStar(pattern, pt + start)

        p := pattern[start:end]
        if start == 0 {
            if !hasPrefix(input, p) return false
            if end == npattern {
                if len(input) != npattern return false
                return true
            }
        } else if end == npattern {
            n := end - start
            if !hasPrefix(input[ninput - n:], p) return false
            return true
        }

        found := find(input, i, p)
        if found == len(input) return false
        i = found + len(p)
        pt = end
    }
}

func TestIsMatch() {
    assert(!IsMatch("aa", "a"))
    assert(IsMatch("aa", "aa"))
    assert(!IsMatch("aaa", "aa"))
    assert(IsMatch("aa", "*"))
    assert(IsMatch("aa", "a*"))
    assert(IsMatch("ab", "?*"))
    assert(!IsMatch("aab", "c*a*b"))
    assert(IsMatch("aaaaa", "aaaaa"))
    assert(IsMatch("aabaa", "aa?aa"))
    assert(IsMatch("aaTaa", "aa?aa"))
    assert(IsMatch("aaTaa", "*T?a"))
    assert(IsMatch("xaaTaa", "x*T?a"))
    assert(IsMatch("xtaaTaa", "x*T?a"))
    assert(!IsMatch("txaaTaa", "x*T?a"))
    assert(IsMatch("xxTaaTaa", "*T?a"))
    assert(IsMatch("xxTaaTaa", "*T????a"))
    assert(IsMatch("xxTTaaTaa", "*T????a"))
    assert(IsMatch("xxTaaTaa", "*T*T?a"))
    assert(IsMatch("xxTaaTaa", "*Ta*"))
    assert(!IsMatch("xxTaaTaa", "*Tab*"))
}
