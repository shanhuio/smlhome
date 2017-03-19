// Rand is a pseudo-random number generator
struct Rand {
    inited bool
    s source
}

// RandInit initializes the random number generator with the system
// random source.
func (r *Rand) RandInit() {
    r.Init(SysRand())
}

// Init initializes the random number generator with the given seed.
func (r *Rand) Init(seed uint) {
    r.s.init(seed)
    r.inited = true
}

// Uint returns a random uint normally distributed from 1 to 2^32-1
func (r *Rand) Uint() uint {
    if !r.inited {
        r.Init(0)
    }
    return r.s.read()
}

// Int returns a random int.
func (r *Rand) Int() int {
    return int(r.Uint() >> 1)
}

// IntN is a shorthand for r.Int() % n
func (r *Rand) IntN(n int) int {
    return r.Int() % n
}

func TestRand() {
    var r Rand
    assert(r.Uint() != r.Uint())
    assert(r.Int() != r.Int())
}

func TestIntN() {
    const n = 24
    var r Rand
    var counts [n]int

    for i := 0; i < 100; i++ {
        x := r.IntN(n)
        counts[x]++
    }
    for i := 0; i < n; i++ {
        assert(counts[i] != 0)
    }
}
