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
    if !l.doorOpen return
    if l.full() return
    if l.direction == 0 return
    queueToLift(f.queue(l.direction), l)
}

func shuffleLifts(l0, l1 *lift) (*lift, *lift) {
    if rand.IntN(2) == 0 return l1, l0
    return l0, l1
}

func loadLifts(f *floor, l0, l1 *lift) {
    if !l1.doorOpen {
        loadLift(f, l0)
    }
    if !l0.doorOpen {
        loadLift(f, l1)
    }
    if l0.direction != l1.direction {
        loadLift(f, l0)
        loadLift(f, l1)
        return
    }
    if l0.direction == 0 return
    queueToLifts(f.queue(l0.direction), l0, l1)
}
