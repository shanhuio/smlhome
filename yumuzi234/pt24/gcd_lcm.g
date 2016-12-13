func GCD(a, b int) int {
    if a < 0 || b < 0 {
        panic()
    }
    if a > b {
        temp := a
        a = b
        b = temp
    }
    temp := b % a
    for temp != 0 {
        b = a
        a = temp
        temp = b % a
    }
    return a
}

func LCM(a, b int) int {
    if a < 0 || b < 0 {
        panic()
    }
    gcd := GCD(a, b)
    return a / gcd * b
}

func TestGcdLcm() {
    assert(GCD(3, 1) == 1)
    assert(GCD(2, 3) == 1)
    assert(GCD(30, 10) == 10)
    assert(GCD(12, 30) == 6)
    assert(LCM(3, 1) == 3)
    assert(LCM(3, 2) == 6)
    assert(LCM(30, 11) == 330)
    assert(LCM(30, 20) == 60)
    assert(LCM(24, 42) == 168)
}
