func gap() uint8 {
    var aWhile long.Long
    aWhile.Iset(1e8)

    var timer time.Timer
    t := time.Now()
    t.Add(&aWhile)
    timer.SetDeadline(&t)
    var s events.Selector

    k := uint8(0)
    for {
        ev := s.Select(nil, &timer)
        if ev == events.Timer {
            break
        } else if ev == events.KeyDown {
            if k == 0 {
                k = s.LastKeyCode()
            }
        }
    }

    return k
}
