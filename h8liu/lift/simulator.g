struct simulator {
    t int
    nfloor int
    lifts [nlift]lift
    floors [maxFloor]floor

    ups Bitmap
    downs Bitmap
}

func (s *simulator) init(nfloor int) {
    s.nfloor = nfloor
    s.t = 0
    for i := 0; i < nfloor; i++ {
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
}

func (s *simulator) now() int {
    return s.t
}

func (s *simulator) printState() {
    terminal.PrintStr("T=")
    terminal.PrintInt(s.now())
    terminal.PrintStr("\n\n")

    for i := s.nfloor - 1; i >= 0; i-- {
        f := &s.floors[i]

        if s.lifts[0].floor == i {
            terminal.PrintStr(" L0")
        } else {
            terminal.PrintStr("   ")
        }

        if s.lifts[1].floor == i {
            terminal.PrintStr(" L1")
        } else {
            terminal.PrintStr("   ")
        }

        terminal.PrintStr("  ")

        f.printState()
        terminal.PrintStr("\n")
    }

    terminal.PrintStr("\n")

    terminal.PrintStr("L0: ")
    s.lifts[0].printState(s.nfloor)
    terminal.PrintStr("\n")

    terminal.PrintStr("L1: ")
    s.lifts[1].printState(s.nfloor)
    terminal.PrintStr("\n")
}

func (s *simulator) step() {
    for i := 0; i < s.nfloor; i++ {
        s.floors[i].update()
    }

    l0 := &s.lifts[0]
    l1 := &s.lifts[1]

    l0.applyAction(s.nfloor)
    l1.applyAction(s.nfloor)

    l0.unload()
    l1.unload()

    f0 := &s.floors[l0.floor]
    f1 := &s.floors[l1.floor]

    if l0.doorOpen {
        f0.popButton(l0.direction)
    }
    if l1.doorOpen {
        f1.popButton(l1.direction)
    }

    if f0 == f1 {
        loadLifts(f0, l0, l1)
    } else {
        loadLift(f0, l0)
        loadLift(f1, l1)
    }

    s.t++
}

var sched0, sched1 scheduler

func (s *simulator) prepareButtons() {
    var ups, downs Bitmap
    for i := 0; i < s.nfloor; i++ {
        if s.floors[i].buttonUp {
            ups.Set(i)
        }
        if s.floors[i].buttonDown {
            downs.Set(i)
        }
    }

    s.ups = ups
    s.downs = downs
}

func (s *simulator) fillView(v *View, this, other *lift) {
    v.Nfloor = s.nfloor
    v.DoorOpen = this.doorOpen
    v.Npassenger = this.npassenger
    v.Current = this.floor
    v.FloorUpButtons = s.ups
    v.FloorDownButtons = s.downs
    v.InsideButtons = this.buttons
    v.OtherLift = other.floor
}

func (s *simulator) scheduleLift(sched *scheduler, this, other *lift) {
    var v View
    var a Action

    s.fillView(&v, this, other)
    sched.schedule(&v, &a)
    this.saveAction(&a)
}

func (s *simulator) schedule() {
    s.prepareButtons()
    s.scheduleLift(&sched0, &s.lifts[0], &s.lifts[1])
    s.scheduleLift(&sched1, &s.lifts[1], &s.lifts[0])
}
