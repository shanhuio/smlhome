struct Long {
    Hi uint32
    Lo uint32
}

func Min(a, b *Long) Long {
    if a.LargerThan(b) return *b
    return *a
}

func (u *Long) IsZero() bool {
    return u.Hi == 0 && u.Lo == 0
}

func (u *Long) Clear() {
    u.Hi = 0
    u.Lo = 0
}

func (u *Long) SetImax() {
    u.Hi = (^uint32(0)) >> 1
    u.Lo = ^uint32(0)
}

func (u *Long) Sign() uint32 {
    return u.Hi >> 31
}

func (u *Long) Positive() bool {
    return !u.IsZero() && u.Sign() == 0
}

func (u *Long) Negative() bool {
    return !u.IsZero() && u.Sign() == 1
}

func (u *Long) Set(high, low uint32) {
    u.Hi = high
    u.Lo = low
}

func (u *Long) Iset(v int32) {
    if v < 0 {
        u.Hi = ^uint32(0)
        u.Lo = uint32(v)
    } else {
        u.Hi = 0
        u.Lo = uint32(v)
    }
}

func (u *Long) Uset(v uint32) {
    u.Hi = 0
    u.Lo = v
}

func (u *Long) Uadd(v uint32) {
    var n Long
    n.Uset(v)
    u.Add(&n)
}

// Add adds a long in, returns the carry.
func (u *Long) Add(n *Long) uint32 {
    lh1, ll1 := hiLo(u.Lo)
    hh1, hl1 := hiLo(u.Hi)
    lh2, ll2 := hiLo(n.Lo)
    hh2, hl2 := hiLo(n.Hi)

    var t, hi, lo uint32
    t, lo = hiLo(ll1 + ll2)
    t, hi = hiLo(lh1 + lh2 + t)
    u.Lo = bind(hi, lo)

    t, lo = hiLo(hl1 + hl2 + t)
    t, hi = hiLo(hh1 + hh2 + t)
    u.Hi = bind(hi, lo)
    return t
}

// Usub subtracts a uint32.
func (u *Long) Usub(v uint32) {
    var n Long
    n.Uset(v)
    n.Negate()
    u.Add(&n)
}

// Sub subtracts the number. Returns the carry.
func (u *Long) Sub(n *Long) uint32 {
    t := *n
    t.Negate()
    return u.Add(&t)
}

// Iadd adds a int32.
func (u *Long) Iadd(v int32) {
    if v < 0 {
        u.Usub(uint32(-v))
    } else {
        u.Uadd(uint32(v))
    }
}

// Imul multiplies a int32.
func (u *Long) Imul(v int32) {
    // TODO:
}

// Inc increases the number by one. Returns the carry.
func (u *Long) Inc() uint32 {
    u.Lo++
    if u.Lo == 0 {
        u.Hi++
    }
    if u.Hi == 0 return 1
    return 0
}

// Negate returns the negation of the number.
func (u *Long) Negate() {
    u.Hi = ^u.Hi
    u.Lo = ^u.Lo
    u.Inc()
}

// Ival returns the int32 value of the number.
func (lo *Long) Ival() int32 {
    return int32(lo.Lo)
}

// Multiple with v and shift 16 bit to the right.
// v must be with-in 16-bit.
func (lo *Long) mulAndShift16(v uint32) {
    lh, ll := hiLo(lo.Lo)
    hh, hl := hiLo(lo.Hi)
    p1h, _ := hiLo(ll * v)
    p2h, p2l := hiLo(lh * v)
    p3h, p3l := hiLo(hl * v)
    p4h, p4l := hiLo(hh * v)

    var t, h uint32
    t, lo.Lo = hiLo(p1h + p2l)
    t, h = hiLo(p2h + p3l + t)
    lo.Lo |= h << 16
    t, lo.Hi = hiLo(p3h + p4l + t)
    t, h = hiLo(p4h + t)
    lo.Hi |= h << 16
    _ := t
}

func (lo *Long) shiftRight16() {
    lo.Lo >>= 16
    lo.Lo |= lo.Hi << 16
    lo.Hi >>= 16
}

func (lo *Long) ShiftRight(n uint) {
    lo.Lo >>= n
    lo.Lo |= lo.Hi << (32 - n)
    lo.Hi >>= n
}

// UdivU16 divides the number with a small 16-bit number.
// Returns the modular.
func (lo *Long) UdivU16(v uint32) uint32 {
    m := lo.Hi % v
    lo.Hi = lo.Hi / v
    lh, ll := hiLo(lo.Lo)
    t := (m << 16) | lh
    m = t % v
    lh = t / v
    t = (m << 16) | ll
    ll = t / v
    lo.Lo = (lh << 16) | ll
    return t % v
}

func (lo *Long) UmulU16(v uint32) {
    lh, ll := hiLo(lo.Lo)
    hh, hl := hiLo(lo.Hi)

    var c1, c2, c3, c uint32
    c1, ll = hiLo(ll * v)
    c2, lh = hiLo(lh * v)
    c3, hl = hiLo(lh * v)
    c, hh = hiLo(hh * v)

    c, lh = hiLo(lh + c1)
    c, hl = hiLo(hl + c2 + c)
    c, hh = hiLo(hh + c3 + c)

    lo.Lo = bind(lh, ll)
    lo.Hi = bind(hh, hl)
}

func (lo *Long) Udiv1e9() {
    lo.UdivU16(1000)
    lo.UdivU16(1000)
    lo.UdivU16(1000)
}

func (lo *Long) Umul1e9() {
    lo.UmulU16(1000)
    lo.UmulU16(1000)
    lo.UmulU16(1000)
}

func (lo *Long) ToWire(buf []byte) {
    binary.PutU32(buf[0:4], lo.Lo)
    binary.PutU32(buf[4:8], lo.Hi)
}

func (lo *Long) Equals(other *Long) bool {
    return lo.Hi == other.Hi && lo.Lo == other.Lo
}

func (lo *Long) LargerThan(other *Long) bool {
    hi1 := int32(lo.Hi)
    hi2 := int32(other.Hi)
    if hi1 > hi2 return true
    if hi1 < hi2 return false
    return lo.Lo > other.Lo
}
