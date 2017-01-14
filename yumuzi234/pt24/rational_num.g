struct RationalNum {
    // num=n/d
    n int
    d int
}

func (r *RationalNum) Print() {
    fmt.PrintInt(r.n)
    fmt.PrintChar('/')
    fmt.PrintInt(r.d)
    fmt.Println()
}

func (r *RationalNum) reduce() {
    if r.n == 0 {
        r.d = 1
        return
    }

    n := r.n
    if n < 0 {
        n = 0 - n
    }
    factor := GCD(n, r.d)
    if (factor != 1) {
        r.n /= factor
        r.d /= factor
    }
}

func (r *RationalNum) Set(p, q int) {
    if q <= 0 {
        panic()
    }
    r.n = p
    r.d = q
    r.reduce()
}

func (r *RationalNum) SetInt(p int) {
    r.n = p
    r.d = 1
}

func (r *RationalNum) isZero() bool {
    return r.n == 0
}

func (r *RationalNum) Equals(a *RationalNum) bool {
    if r.isZero() && a.isZero() return true
    if r.n != a.n return false
    if r.d != a.d return false
    return true
}

func (r *RationalNum) EqualsInt(i int) bool {
    var a RationalNum
    a.SetInt(i)
    return r.Equals(&a)
}

func (r *RationalNum) Add(a *RationalNum) {
    r.n = r.n * a.d + a.n * r.d
    r.d *= a.d
    r.reduce()
}

func (r *RationalNum) AddInt(a int) {
    r.n = r.n + a * r.d
}

func (r *RationalNum) Sub(a *RationalNum) {
    lcm := LCM(r.d, a.d)
    r.n = r.n * (lcm / r.d) - a.n * (lcm / a.d)
    r.d = lcm
    r.reduce()
}

func (r *RationalNum) SubInt(a int) {
    r.n = r.n - a * r.d
}

func (r *RationalNum) Mul(a *RationalNum) {
    r.n *= a.n
    r.d *= a.d
    r.reduce()
}

func (r *RationalNum) MulInt(a int) {
    r.n *= a
    r.reduce()
}

func (r *RationalNum) Inv() {
    if r.n == 0 {
        panic()
    }
    if r.n < 0 {
        temp := 0 - r.n
        r.n = 0 - r.d
        r.d = temp
    } else {
        temp := r.n
        r.n = r.d
        r.d = temp
    }
}

func (r *RationalNum) Div(a *RationalNum) {
    var temp RationalNum
    temp.Set(a.n, a.d)
    temp.Inv()
    r.Mul(&temp)
}

func (r *RationalNum) DivInt(a int) {
    if a == 0 {
        panic()
    }
    if a > 0 {
        r.d *= a
    } else {
        r.n = -r.n
        a = -a
        r.d *= a
    }
    r.reduce()
}
