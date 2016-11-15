func main() {
    const misClickLimit = 3
    rand.SysSeed()
    for {
        diff := menu()
        replay := true
        for replay {
            replay = game(diff, misClickLimit)
        }
        // gap()
    }
}

func gap() {
    var aWhile long.Long
    aWhile.Uset(350000000)
    var timer time.Timer
    t := time.Now()
    t.Add(&aWhile)
    timer.SetDeadline(&t)
    var s events.Selector
    for {
        ev := s.Select(nil, &timer)
        if ev == events.Timer {
            break
        }
    }
}
// func main() {

//     const misClickLimit = 3
//     var i2aBuf [8]byte
//     rand.SysSeed()

//     for {
//         var prop table.Prop

//         now := time.Now()
//         var ticker time.Ticker
//         interval := easy
//         interval.UmulU16(1)
//         ticker.Start(&now, &interval)

//         var c *table.CardProp = nil
//         var s events.Selector
//         var pool PosPool
//         var score int

//         // Initialization
//         score = 0
//         for i := 0; i < 24; i++ {
//             pool.Append(i)
//         }
//         misClick := 0

//         for {
//             table.Render(&prop)

//             ev := s.Select(&ticker, nil)
//             if ev == events.Ticker {
//                 if c != nil {
//                     c.Visible = true
//                     c.FaceUp = false
//                     misClick++
//                     if misClick == misClickLimit break
//                 }
//                 if pool.IsEmpty() break // end of game
//                 c = &prop.Cards[pool.PopRand()]
//                 c.Visible = true
//                 c.Face = 'A' + char(rand.IntN(26))
//                 c.FaceUp = true
//             } else if ev == events.Click {
//                 what, pos := s.LastClick()
//                 if what == table.OnCard {
//                     clicked := &prop.Cards[pos]
//                     if clicked.Visible && clicked.FaceUp {
//                         // To make sure not count twice when click very fast
//                         score++
//                         prop.Texts[0] = i2a(i2aBuf[:], score)
//                         pool.Append(pos)
//                         prop.Cards[pos].Visible = false
//                         c = nil
//                     }
//                 }
//             }
//         }
//         prop.Texts[0] = "Game over, your score is"
//         prop.Texts[1] = i2a(i2aBuf[:], score)
//         table.Render(&prop)

//         s.Select(nil, nil)
//     }
// }
