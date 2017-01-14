struct PeekIterator {
    saving bool
    next int
    iter *Iterator
}

func (pi *PeekIterator) Init(iter *Iterator) {
    pi.iter = iter
    pi.saving = false
}

func (pi *PeekIterator) HasNext() bool {
    if pi.saving return true
    return pi.iter.HasNext()
}

func (pi *PeekIterator) Next() int {
    if pi.saving {
        ret := pi.next
        pi.saving = false
        return ret
    }

    return pi.iter.Next()
}

func (pi *PeekIterator) Peek() int {
    if pi.saving return pi.next

    pi.saving = true
    pi.next = pi.iter.Next()
    return pi.next
}

func TestPeekIterator() {
    dat := []int{0, 1, 2, 3}
    var it Iterator
    it.Init(dat)
    var pi PeekIterator
    pi.Init(&it)

    assert(pi.Next() == 0)
    assert(pi.HasNext())
    assert(pi.Peek() == 1)
    assert(pi.HasNext())
    assert(pi.Next() == 1)
    assert(pi.HasNext())
    assert(pi.Peek() == 2)
    assert(pi.Peek() == 2)
    assert(pi.Next() == 2)
    assert(pi.HasNext())
    assert(pi.Next() == 3)
    assert(!pi.HasNext())
}
