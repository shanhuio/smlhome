struct person {
    src int // from which floor
    dest int // to which floor
    expire int // time point where the person will give up and go with floors
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
    return ret
}

func tailPerson(p *person) *person {
    if p == nil return nil

    for p.next != nil {
        p = p.next
    }
    return p
}
