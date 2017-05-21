struct simulator {
    t int
    nfloor int
    lifts [nlift]lift
    floors [maxFloor]floor
}

func (s *simulator) init(nfloor int) {
    s.nfloor = nfloor
    s.t = 0
    for i := 0; i < s.nfloor; i++ {
        s.floors[i].init(i)
    }
}

func (s *simulator) addPerson(src, dest int) {
    if src == dest return
    s.floors[src].add(dest)
}

func (s *simulator) addPersons() {
    // we just add one person for now
    r := rand.Int()
    if (r & 0x1) == 0 return
    r >>= 1

    bit := r & 0x1
    r >>= 1
    if bit == 0 {
        if (r & 0x1) == 0 {
            src := r % s.nfloor
            s.addPerson(src, 0)
        } else {
            dest := r % s.nfloor
            s.addPerson(0, dest)
        }
    } else {
        src := r % s.nfloor
        r /= s.nfloor
        dest := r % s.nfloor
        s.addPerson(src, dest)
    }

    // TODO: add persons to floors
}

func (s *simulator) now() int {
    return s.t
}

func (s *simulator) step() {
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

    s.t++
}

var sched0, sched1 scheduler

func (s *simulator) schedule() {
    var ups, downs Bitmap
    for i := 0; i < s.nfloor; i++ {
        if s.floors[i].buttonUp {
            ups.Set(i)
        }
        if s.floors[i].buttonDown {
            downs.Set(i)
        }
    }

    var v0 View
    v0.FloorUpButtons = ups
    v0.FloorDownButtons = downs
    v0.InsideButtons = s.lifts[0].buttons
    v0.OtherLift = s.lifts[1].floor
    var a0 Action
    sched0.schedule(&v0, &a0)
    s.lifts[0].saveAction(&a0)

    var v1 View
    v1.FloorUpButtons = ups
    v1.FloorDownButtons = downs
    v1.InsideButtons = s.lifts[1].buttons
    v1.OtherLift = s.lifts[0].floor
    var a1 Action
    sched1.schedule(&v1, &a1)
    s.lifts[1].saveAction(&a1)
}
