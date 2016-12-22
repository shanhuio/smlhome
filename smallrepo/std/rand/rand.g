// Rand is a pseudo-random number generator
struct Rand {
    x uint
}

// RandInit initializes the random number generator with the system
// random source.
func (r *Rand) RandInit() {
    r.Init(SysRand())
}

// Init initializes the random number generator with the given seed.
func (r *Rand) Init(seed uint) {
    r.x = seed
}

// Uint returns a random uint normally distributed from 1 to 2^32-1
func (r *Rand) Uint() uint {
    // TODO(h8liu): this is incorrect.
    if r.x == 0 {
        r.x = 89482311
    }
    r.x *= 48271
    return r.x
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
    x := r.Uint()
    y := r.Uint()
    assert(x != y)

    i1 := r.Int()
    i2 := r.Int()
    assert(i1 != i2)
}

func TestIntN() {
    const n = 5
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
