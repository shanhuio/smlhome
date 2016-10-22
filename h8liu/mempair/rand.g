struct Rand {
    x uint
}

func (r *Rand) init(seed uint) {
    r.x = seed
    if r.x == 0 {
        r.x = 89482311
    }
}

func (r *Rand) Uint() uint {
    r.x *= 48271
    return r.x
}
