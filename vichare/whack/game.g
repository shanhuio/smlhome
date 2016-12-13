var i2aBuf [8]byte

var i2aBuf2 [8]byte

func speedUp(interval int, step int) int {
    return interval / 1000 * (1000 - step)
}

func setTimer(t *time.Timer, interval int) {
    ts := time.Now()
    ts.Iadd(interval)
    t.SetDeadline(&ts)
}

func game(interval, step, limit int) bool {
    var prop table.Prop
    var timer time.Timer
    var c *table.CardProp = nil
    var s events.Selector
    var pool PosPool
    var pos int

    // Initialization
    life := limit
    score := 0
    for i := 0; i < 24; i++ {
        pool.Append(i)
    }

    prop.Texts[0] = "score"
    prop.Texts[1] = "0"
    prop.Texts[2] = "life"
    prop.Texts[3] = i2a(i2aBuf2[:], life)
    prop.Buttons[0].Visible = true
    prop.Buttons[0].Text = "return"

    setTimer(&timer, interval)

    for {
        table.Render(&prop)

        ev := s.Select(nil, &timer)
        if ev == events.Timer {
            if c != nil { // has a card on board, but time up.
                if c.Face == 'W' && c.FaceUp {
                    score++
                    prop.Texts[1] = i2a(i2aBuf[:], score)
                    pool.Append(pos)
                    prop.Cards[pos].Visible = false
                    c = nil
                } else if c.Face == 'M' {
                    c.Visible = true
                    c.FaceUp = false
                    life--
                    prop.Texts[3] = i2a(i2aBuf2[:], life)
                    if life == 0 break
                }
            }
            // show another card
            pos = pool.PopRand()
            c = &prop.Cards[pos]
            c.Visible = true
            if rand.IntN(5) == 0 {
                c.Face = 'W'
            } else {
                c.Face = 'M'
            }
            c.FaceUp = true
            interval = speedUp(interval, step)
            setTimer(&timer, interval)
        } else if ev == events.Click {
            what, where := s.LastClick()
            if what == table.OnButton {
                return false
            }
            if what == table.OnCard {
                clicked := &prop.Cards[where]
                if clicked.Visible && clicked.FaceUp {
                    // To make sure not count twice when click very fast
                    if c.Face == 'M' {
                        score++
                        prop.Texts[1] = i2a(i2aBuf[:], score)
                        pool.Append(where)
                        prop.Cards[where].Visible = false
                        c = nil
                    } else {
                        c.Visible = true
                        c.FaceUp = false
                        life--
                        prop.Texts[3] = i2a(i2aBuf2[:], life)
                        if life == 0 break
                    }
                }
            }
        }
    }

    prop.Texts[0] = "Game over, your score is"
    prop.Texts[2] = ""
    prop.Texts[3] = ""
    prop.Buttons[0].Visible = true
    prop.Buttons[0].Text = "replay"
    prop.Buttons[1].Visible = true
    prop.Buttons[1].Text = "menu"
    table.Render(&prop)

    for {
        ev := s.Select(nil, nil)
        if ev == events.Click {
            what, pos := s.LastClick()
            if what == table.OnButton {
                if pos == 0 return true
                return false
            }
        }
    }
}
