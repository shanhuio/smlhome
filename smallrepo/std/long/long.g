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

func (lo *Long) Iset(v int32) {
    if v < 0 {
        lo.Hi = ^uint32(0)
        lo.Lo = uint32(v)
    } else {
        lo.Hi = 0
        lo.Lo = uint32(v)
    }
}

func (lo *Long) Uadd(v uint32) {
    // TODO
}

func (lo *Long) Usub(v uint32) {
    // TODO
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

func (lo *Long) Udiv(v uint32) {
    // TODO:
}

func (lo *Long) Idiv(v int32) {
    if v == 0 {
        panic()
    }

    if v > 0 {
        if lo.Negative() {
            lo.Negate()
            lo.Udiv(uint32(v))
            lo.Negate()
        } else {
            lo.Udiv(uint32(v))
        }
    } else {
        v = -v
        if lo.Negative() {
            lo.Negate()
            lo.Udiv(uint32(v))
        } else {
            lo.Udiv(uint32(v))
            lo.Negate()
        }
    }
}

func (lo *Long) ToWire(buf []byte) {
    binary.PutU32(buf[0:4], lo.Lo)
    binary.PutU32(buf[4:8], lo.Hi)
}
