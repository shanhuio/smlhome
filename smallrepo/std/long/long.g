func hiLo(v uint32) (uint32, uint32) {
    return v >> 16, v & 0xffff
}

struct Long {
    Hi uint32
    Lo uint32
}

func (lo *Long) IsZero() bool {
    return lo.Hi == 0 && lo.Lo == 0
}

func (lo *Long) Sign() uint32 {
    return (lo.Hi >> 31) & 0x1
}

func (lo *Long) Positive() bool {
    return !lo.IsZero() && lo.Sign() == 0
}

func (lo *Long) Negative() bool {
    return !lo.IsZero() && lo.Sign() == 1
}

func (lo *Long) Set(high, low uint32) {
    lo.Hi = high
    lo.Lo = low
}

func (lo *Long) Iset(v int32) {
    if v < 0 {
        lo.Hi = ^uint32(0)
        lo.Lo = uint32(v)
    } else {
        lo.Hi = 0
        lo.Lo = uint32(v)
    }
}

func (lo *Long) Uset(v uint32) {
    lo.Hi = 0
    lo.Lo = v
}

func (lo *Long) Uadd(v uint32) {
    var n Long
    n.Uset(v)
    lo.Add(&n)
}

func (lo *Long) Add(n *Long) {
    lh1, ll1 := hiLo(lo.Lo)
    hh1, hl1 := hiLo(lo.Hi)
    lh2, ll2 := hiLo(n.Lo)
    hh2, hl2 := hiLo(n.Hi)

    var t, hi uint32
    t, lo.Lo = hiLo(ll1 + ll2)
    t, hi = hiLo(lh1 + lh2 + t)
    lo.Lo |= (hi << 16)

    t, lo.Hi = hiLo(hl1 + hl2 + t)
    t, hi = hiLo(hh1 + hh2 + t)
    lo.Hi |= (hi << 16)
    _ := t
}

func (lo *Long) Usub(v uint32) {
    var n Long
    n.Uset(v)
    n.Negate()
    lo.Add(&n)
}

func (lo *Long) Sub(n *Long) {
    t := *n
    t.Negate()
    lo.Add(n)
}

func (lo *Long) Iadd(v int32) {
    if v < 0 {
        lo.Usub(uint32(-v))
    } else {
        lo.Uadd(uint32(v))
    }
}

func (lo *Long) Inc() {
    lo.Lo++
    if lo.Lo == 0 {
        lo.Hi++
    }
}

func (lo *Long) Negate() {
    lo.Hi = ^lo.Hi
    lo.Lo = ^lo.Lo
    lo.Inc()
}

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

func (lo *Long) Udiv1e9() {
    lo.UdivU16(1000)
    lo.UdivU16(1000)
    lo.UdivU16(1000)
}

func (lo *Long) ToWire(buf []byte) {
    binary.PutU32(buf[0:4], lo.Lo)
    binary.PutU32(buf[4:8], lo.Hi)
}

func (lo *Long) Equals(other *Long) bool {
    return lo.Hi == other.Hi && lo.Lo == other.Lo
}
