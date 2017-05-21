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

func printPersons(p *person) {
    if p == nil {
        fmt.PrintStr("-")
        return
    }
    for ; p != nil; p = p.next {
        fmt.PrintInt(p.dest)
    }
}
