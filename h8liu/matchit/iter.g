struct iter {
    buf [size + 2]int
    n int

    min int
    max int
}

func (it *iter) add(v int) {
    if !(v >= it.min && v <= it.max) return
    it.buf[it.n] = v
    it.n++
}

func (it *iter) addRange(start, end int) {
    if start < it.min {
        start = it.min
    }
    if end > it.max {
        end = it.max
    }

    for i := start; i <= end; i++ {
        it.add(i)
    }
}

func (it *iter) addRangeRev(start, end int) {
    if start < it.min {
        start = it.min
    }
    if end > it.max {
        end = it.max
    }

    for i := end; i >= start; i-- {
        it.add(i)
    }
}

func (it *iter) build(n1, n2, min, max int) []int {
    assert(n1 >= 0 && n1 < size)
    assert(n2 >= 0 && n2 < size)
    assert(min >= -1 && min <= size)
    assert(max >= -1 && max <= size)
    assert(max >= min)

    if n1 > n2 {
        n1, n2 = n2, n1
    }

    it.min = min
    it.max = max
    it.n = 0

    it.add(n1)
    if n1 != n2 {
        it.add(n2)
    }
    it.addRange(n1 + 1, n2 - 1)
    it.addRangeRev(min, n1 - 1)
    it.addRange(n2 + 1, max)

    return it.buf[:it.n]
}
