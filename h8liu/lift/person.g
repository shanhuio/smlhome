struct person {
    src int // from which floor
    dest int // to which floor
    expire int // time point where the person will give up and go with stairs
    next *person
}

func insertPerson(at **person, p *person) {
    hold := *at
    *at = p
    p.next = hold
}

func removePerson(at **person) *person {
    ret := *at
    *at = ret.next
    ret.next = nil
    return ret
}

func tailPerson(p **person) **person {
    if *p == nil return p

    for (*p).next != nil {
        p = &((*p).next)
    }

    return p
}

func personLen(p *person) int {
    ret := 0
    for p != nil {
        ret++
        p = p.next
    }
    return ret
}

func printPersons(p *person) {
    if p == nil {
        terminal.PrintStr("-")
        return
    }

    for p != nil {
        terminal.PrintInt(p.dest)

        p = p.next
    }
}

func TestPersonList() {
    var p0, p1 person
    p0.dest = 1
    p1.dest = 2

    var pt *person
    assert(personLen(pt) == 0)

    insertPerson(&pt, &p0)
    assert(personLen(pt) == 1)
    assert(pt == &p0)

    tail := pt
    assert(*tailPerson(&tail) == &p0)
    assert(*tailPerson(&tail) == pt)

    insertPerson(&pt, &p1)
    assert(personLen(pt) == 2)
    assert(pt == &p1)
    tail = pt
    assert(*tailPerson(&tail) == &p0)

    got := removePerson(&pt)
    assert(got == &p1)
    assert(got.next == nil)
    assert(pt == &p0)
    tail = pt
    assert(personLen(pt) == 1)
    assert(*tailPerson(&tail) == &p0)

    got = removePerson(&pt)
    assert(got == &p0)
    assert(got.next == nil)
    assert(pt == nil)
    assert(personLen(pt) == 0)
    assert(*tailPerson(&pt) == nil)
}
