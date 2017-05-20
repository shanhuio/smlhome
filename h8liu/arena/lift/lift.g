const nlift = 2

const liftCap = 10

struct lift {
    floor int // which floor the lift is currently on
    doorOpen bool // if the door is opened
    passengers *person // passengers inside the lift
    npassenger int
    buttons bitmap // the state of the lift buttons
    direction int // 1 for up, 0 for noop, -1 for down
    action int
}

func (l *lift) applyAction() {
    switch l.action {
    case ActionNoop:
    case ActionOpenDoor:
        l.doorOpen = true
        l.buttons.clear(l.floor)
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
            *pp = (*pp).next
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
    l.npassenger++
    return true
}
