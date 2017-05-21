struct scheduler {
    direction int
}

func (s *scheduler) schedule(v *View, action *Action) {
    highest := 0
    lowest := v.Nfloor

    if s.direction == 0 {
        s.direction = 1
    }

    for i := 0; i < v.Nfloor; i++ {
        need := v.FloorUpButtons.Get(i)
        need = need || v.FloorDownButtons.Get(i)
        need = need || v.InsideButtons.Get(i)
        if !need continue

        if i > highest {
            highest = i
        }
        if i < lowest {
            lowest = i
        }
    }

    cur := v.Current
    curUp := v.FloorUpButtons.Get(cur)
    curDown := v.FloorDownButtons.Get(cur)

    if s.direction > 0 {
        if v.Current == highest && !curUp {
            s.direction = -1
        }
    } else if s.direction < 0 {
        if v.Current == lowest && !curDown {
            s.direction = 1
        }
    }

    action.Direction = s.direction

    if curUp || curDown || v.InsideButtons.Get(cur) {
        if !v.DoorOpen {
            action.Action = ActionOpenDoor
            return
        }
    }

    if v.DoorOpen {
        action.Action = ActionCloseDoor
        return
    }

    if s.direction > 0 && highest > cur {
        action.Action = ActionUp
    } else if s.direction < 0 && lowest < cur {
        action.Action = ActionDown
    }
}
