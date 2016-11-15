var i2aBuf [8]byte

var i2aBuf2 [8]byte

func game(diff long.Long, limit int) bool {
    var prop table.Prop
    now := time.Now()
    var ticker time.Ticker
    ticker.Start(&now, &diff)
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

    for {
        table.Render(&prop)
        ev := s.Select(&ticker, nil)
        if ev == events.Ticker {
            if c != nil {
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
            pos = pool.PopRand()
            c = &prop.Cards[pos]
            c.Visible = true
            if rand.IntN(5) == 0 {
                c.Face = 'W'
            } else {
                c.Face = 'M'
            }
            c.FaceUp = true
        } else if ev == events.Click {
            what, where := s.LastClick()
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
