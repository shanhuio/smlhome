const nlift = 2

const liftCap = 10

struct lift {
    floor int // which floor the lift is currently on
    doorOpen bool // if the door is opened
    passengers *person // passengers inside the lift
    npassenger int
    buttons Bitmap // the state of the lift buttons
    direction int // 1 for up, 0 for noop, -1 for down
    action int
}

func (l *lift) applyAction(nfloor int) {
    switch l.action {
    case ActionNoop:
    case ActionOpenDoor:
        l.doorOpen = true
        l.buttons.Clear(l.floor)
    case ActionCloseDoor:
        l.doorOpen = false
    case ActionUp:
        if !l.doorOpen && l.floor < nfloor - 1 {
            l.floor++
        }
    case ActionDown:
        if !l.doorOpen && l.floor > 0 {
            l.floor--
        }
    }
    l.action = ActionNoop
}

func (l *lift) unload() {
    if !l.doorOpen return

    curFloor := l.floor
    for pp := &l.passengers; *pp != nil;  {
        if (*pp).dest == curFloor {
            out := removePerson(pp)
            // TODO: record score/satisfaction
            freePerson(out)
            l.npassenger--
        } else {
            pp = &((*pp).next)
        }
    }
}

func (l *lift) full() bool {
    return l.npassenger >= liftCap
}

func (l *lift) load(p *person) bool {
    if !l.doorOpen return false
    if l.full() return false
    insertPerson(&l.passengers, p)
    l.buttons.Set(p.dest)
    l.npassenger++
    return true
}

func (l *lift) saveAction(a *Action) {
    l.action = a.Action
    l.direction = a.Direction
}

func (l *lift) printState(nfloor int) {
    fmt.PrintInt(l.floor)
    fmt.PrintStr(" ")

    if l.doorOpen {
        fmt.PrintStr("[ ] ")
    } else {
        fmt.PrintStr("[|] ")
    }

    if l.direction > 0 {
        fmt.PrintStr("U")
    } else if l.direction < 0 {
        fmt.PrintStr("D")
    } else {
        fmt.PrintStr("-")
    }

    fmt.PrintStr(" ")

    switch l.action {
    case ActionNoop:
        fmt.PrintStr("-")
    case ActionOpenDoor:
        fmt.PrintStr("O")
    case ActionCloseDoor:
        fmt.PrintStr("C")
    case ActionUp:
        fmt.PrintStr("U")
    case ActionDown:
        fmt.PrintStr("D")
    default:
        fmt.PrintStr("?")
    }

    fmt.PrintStr(" : ")

    for i := 0; i < nfloor; i++ {
        if l.buttons.Get(i) {
            fmt.PrintInt(i)
            fmt.PrintStr(" ")
        }
    }

    if l.passengers != nil {
        fmt.PrintStr(" : ")

        fmt.PrintStr("(")
        fmt.PrintInt(l.npassenger)
        fmt.PrintStr(") ")

        printPersons(l.passengers)
    }
}
