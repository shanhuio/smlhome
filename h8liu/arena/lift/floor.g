const nfloor = 30

struct floor {
    number int
    queueUp, queueDown *person // passengers waiting for a lift
    buttonUp, buttonDown bool // if the button of going up is pushed
    emerging *person
}

func (f *floor) init(i int) {
    f.number = i
}

func (f *floor) queue(direction int) **person {
    switch direction {
    case 1:
        return &f.queueUp
    case -1:
        return &f.queueDown
    }
    return nil
}

func (f *floor) add(dest int, expire int) {
    if dest == f.number return

    p := allocPerson()
    p.src = f.number
    p.dest = dest
    p.expire = expire

    insertPerson(&f.emerging, p)
}

func (f *floor) emerge() {
    upTail := tailPerson(f.queueUp)
    downTail := tailPerson(f.queueDown)
    for f.emerging != nil {
        p := removePerson(&f.emerging)
        if p.dest > f.number {
            upTail.next = p
            upTail = p
        } else if p.dest < f.number {
            downTail.next = p
            downTail = p
        } else {
            freePerson(p)
        }
    }
}

func (f *floor) popButton(direction int) {
    if direction == 0 return
    if direction == 1 {
        f.buttonUp = false
    }
    if direction == 2 {
        f.buttonDown = false
    }
}

func (f *floor) pushButtons() {
    if f.queueUp != nil {
        f.buttonUp = true
    }
    if f.queueDown != nil {
        f.buttonDown = true
    }
}
