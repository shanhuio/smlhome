const maxFloor = 32

struct floor {
    number int
    queueUp, queueDown *person // passengers waiting for a lift
    buttonUp, buttonDown bool // if the button of going up is pushed
    emerging *person
}

func (f *floor) init(i int) {
    f.number = i
}

func (f *floor) printState() {
    fmt.PrintStr("#")
    fmt.PrintInt(f.number)
    fmt.PrintStr(": ")
    if f.buttonUp {
        fmt.PrintStr("U")
    } else {
        fmt.PrintStr(" ")
    }
    if f.buttonDown {
        fmt.PrintStr("D")
    } else {
        fmt.PrintStr(" ")
    }

    fmt.PrintStr("  ")
    printPersons(f.queueUp)
    fmt.PrintStr(" / ")
    printPersons(f.queueDown)

    if f.emerging != nil {
        fmt.PrintStr(" (")
        printPersons(f.emerging)
        fmt.PrintStr(")")
    }
}

func (f *floor) quiet() bool {
    if f.queueUp != nil return false
    if f.queueDown != nil return false
    if f.emerging != nil return false
    if !f.buttonUp return false
    if !f.buttonDown return false
    return true
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

func (f *floor) add(dest int) {
    if dest == f.number return

    p := allocPerson()
    p.src = f.number
    p.dest = dest
    p.expire = -1

    insertPerson(&f.emerging, p)
}

func (f *floor) update() {
    upTail := tailPerson(&f.queueUp)
    downTail := tailPerson(&f.queueDown)
    for f.emerging != nil {
        p := removePerson(&f.emerging)
        if p.dest > f.number {
            *upTail = p
            upTail = &p.next
        } else if p.dest < f.number {
            *downTail = p
            downTail = &p.next
        } else {
            freePerson(p)
        }
    }

    f.pushButtons()
}

func (f *floor) popButton(direction int) {
    if direction == 0 return
    if direction > 0 {
        f.buttonUp = false
    }
    if direction < 0 {
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
