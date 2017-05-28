struct scheduler {
    direction int
}

func (s *scheduler) schedule(v *View, action *Action) {
    cur := v.Current
    highest := cur
    lowest := cur

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

    curUp := v.FloorUpButtons.Get(cur)
    curDown := v.FloorDownButtons.Get(cur)

    if s.direction > 0 {
        if cur == highest && !curUp {
            s.direction = -1
        }
    } else if s.direction < 0 {
        if cur == lowest && !curDown {
            s.direction = 1
        }
    }

    action.Direction = s.direction

    if !v.DoorOpen {
        open := false
        if v.InsideButtons.Get(cur) {
            open = true
        } else if s.direction > 0 && curUp {
            open = true
        } else if s.direction < 0 && curDown {
            open = true
        }

        if open {
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
