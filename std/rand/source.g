const tableLen = 607

var vecInit []uint32 // of tableLen

struct source {
    tap int // index into vec
    feed int // index into vec
    vec [tableLen]uint32 // current feedback register
}

// seed rng x[n+1] = 48271 * x[n] mod (2**31 - 1)
func seedRand(x int32) int32 {
    const (
        q = 44488
        a = 48271
        m = 0x7fffffff
        r = m - q * a
    )

    hi := x / q
    lo := x % q
    x = a * lo - r * hi
    if x < 0 {
        x += m
    }
    return x
}

func (s *source) init(seed uint32) {
    const (
        tap = 273
        mask31 = (1 << 31) - 1
    )

    s.feed = tableLen - tap

    if seed == 0 {
        seed = 89482311
    }
    seed %= mask31

    x := int32(seed)
    for i := 0; i < 20; i++ {
        x = seedRand(x)
    }

    for i := 0; i < tableLen; i++ {
        u := uint32(x) << 20
        x = seedRand(x)
        u ^= uint32(x)
        u ^= vecInit[i]
        s.vec[i] = u
    }
}

func (s *source) read() uint32 {
    s.tap--
    if s.tap < 0 {
        s.tap += tableLen
    }

    s.feed--
    if s.feed < 0 {
        s.feed += tableLen
    }

    x := s.vec[s.feed] + s.vec[s.tap]
    s.vec[s.feed] = x
    return x
}
