import (
    "table"
    "time"
    "events"
    "long"
)

func main() {
    var p table.Prop
    pic := &p.Pic

    var interval long.Long
    interval.Iset(15000000) // about 60 fps
    now := time.Now()

    var ticker time.Ticker
    ticker.Start(&now, &interval)

    var s events.Selector

    for {
        s.Select(&ticker, nil)
        n := ticker.N()
        if n > 300 {
            break
        }

        stage := n % 100
        
        pic.Visible = true
        if stage < 50 {
            pic.Left = 20 + stage * 2
        } else {
            pic.Left = 20 + (100 - stage) * 2
        }
        pic.Top = 20

        table.Render(&p)
    }
}
