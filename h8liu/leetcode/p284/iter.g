struct Iterator {
    dat []int
    pt int
}

func (it *Iterator) Init(dat []int) {
    it.pt = 0
    it.dat = dat
}

func (it *Iterator) Next() int {
    ret := it.dat[it.pt]
    it.pt++
    return ret
}

func (it *Iterator) HasNext() bool {
    return it.pt < len(it.dat)
}

func TestIterator() {
    var it Iterator
    dat := []int{0, 1, 2, 3, 4}
    it.Init(dat)
    expect := 0
    for it.HasNext() {
        assert(it.Next() == expect)
        expect++
    }
    assert(expect == len(dat))
}
