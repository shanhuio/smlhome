struct simulator {
    nfloor int
    lifts [nlift]lift
    floors [maxFloor]floor
}

func (s *simulator) init(nfloor int) {
    s.nfloor = nfloor
    for i := 0; i < s.nfloor; i++ {
        s.floors[i].init(i)
    }
}

func queueToLift(pp **person, l *lift) {
    for *pp != nil {
        l.load(removePerson(pp))
        if l.full() return
    }
}

func queueToLifts(pp **person, l0, l1 *lift) {
    l0, l1 = shuffleLifts(l0, l1)

    for *pp != nil {
        if l0.full() break
        l0.load(removePerson(pp))
        l0, l1 = l1, l0
    }

    if l0.full() {
        queueToLift(pp, l1)
        return
    }
    if l1.full() {
        queueToLift(pp, l0)
        return
    }
}

func loadLift(f *floor, l *lift) {
    if l.full() return
    if l.direction == 0 return
    queueToLift(f.queue(l.direction), l)
}

func shuffleLifts(l0, l1 *lift) (*lift, *lift) {
    if rand.IntN(2) == 0 return l1, l0
    return l0, l1
}

func loadLifts(f *floor, l0, l1 *lift) {
    if l0.direction != l1.direction {
        loadLift(f, l0)
        loadLift(f, l1)
        return
    }
    if l0.direction == 0 return
    queueToLifts(f.queue(l0.direction), l0, l1)
}

func (s *simulator) step() {
    // TODO: add persons to floors

    l0 := &s.lifts[0]
    l1 := &s.lifts[1]

    l0.applyAction(s.nfloor)
    l1.applyAction(s.nfloor)

    l0.unload()
    l1.unload()

    f0 := &s.floors[l0.floor]
    f1 := &s.floors[l1.floor]

    f0.popButton(l0.direction)
    f1.popButton(l1.direction)

    if f0 == f1 {
        loadLifts(f0, l0, l1)
    } else {
        loadLift(f0, l0)
        loadLift(f1, l1)
    }

    if l0.doorOpen {
        f0.pushButtons()
    }

    if f0 != f1 {
        if l1.doorOpen {
            f1.pushButtons()
        }
    }
}
