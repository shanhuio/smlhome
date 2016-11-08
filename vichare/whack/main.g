var oneSec long.Long

var fiveSec long.Long

func init() {
    oneSec.Uset(1000000000)
    fiveSec = oneSec
    fiveSec.UmulU16(5)
}

func i2a(bs []byte, i int) string {
    var buf bytes.Buffer
    buf.Init(bs)

    fmt.FprintInt(&buf, i)
    return buf.String()
}

func main() {
    const misClickLimit = 3
    var i2aBuf [8]byte

    for {
        var prop table.Prop

        now := time.Now()
        var ticker time.Ticker
        interval := oneSec
        interval.UmulU16(1)
        ticker.Start(&now, &interval)

        var c *table.CardProp = nil
        var s events.Selector
        var pool PosPool
        var score int

        // Initialization
        score = 0
        for i := 0; i < 24; i++ {
            pool.Append(i)
        }
        misClick := 0

        for {
            table.Render(&prop)

            ev := s.Select(&ticker, nil)
            if ev == events.Ticker {
                if c != nil {
                    c.Visible = true
                    c.FaceUp = false
                    misClick++
                    if misClick == misClickLimit break
                }
                if pool.IsEmpty() break // end of game
                c = &prop.Cards[pool.PopRand()]
                c.Visible = true
                c.Face = 'A' + char(misc.Rand() % 26)
                c.FaceUp = true
            } else if ev == events.Click {
                pos, valid := s.LastClick()
                if valid && prop.Cards[pos].Visible && prop.Cards[pos].FaceUp {
                    // To make sure not count twice when click very fast
                    score++
                    prop.Texts[0] = i2a(i2aBuf[:], score)
                    pool.Append(pos)
                    prop.Cards[pos].Visible = false
                    c = nil
                }
            }
        }
        prop.Texts[0] = "Game over, your score is"
        prop.Texts[1] = i2a(i2aBuf[:], score)
        table.Render(&prop)

        s.Select(nil, nil)
    }
}
