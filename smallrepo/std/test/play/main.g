import (
    "events"
    "long"
    "table"
    "time"
    "bytes"
    "fmt"
)

var p table.Prop

var d1 table.Div

var d2 table.Div

var divs [2]*table.Div

func main() {
    // pic := &p.Pic

    var interval long.Long
    // interval.Iset(16666667) // about 60 fps
    interval.Iset(1000000000)
    now := time.Now()

    var ticker time.Ticker
    ticker.Start(&now, &interval)

    var s events.Selector

    divs[0] = &d1
    divs[1] = &d2
    p.Divs = divs[:]

    d1.Key = 1
    d1.Transition = 100
    d1.Visible = true
    d1.Color = 0x990000
    d1.BackgroundColor = 0xffffff
    d1.Width = 60
    d1.Height = 60
    d1.FontSize = 20
    d1.BorderRadius = 3

    d2 = d1
    d2.Key = 2
    d2.Color = 0x009900

    nstage := 10
    step := 20

    var textBuf1 [10]byte
    // var textBuf2 [10]byte
    var w bytes.Buffer

    n := 0
    for {
        stage := n % nstage

        if stage < nstage / 2 {
            d1.Left = uint(20 + stage * step)
        } else {
            d1.Left = uint(20 + (nstage - stage) * step)
        }
        d1.Top = 20

        d2.Left = uint(40 + nstage / 2 * step) - d1.Left
        d2.Top = 100

        w.Init(textBuf1[:])
        fmt.FprintInt(&w, n)
        d1.Text = w.String()

        // w.Init(textBuf2[:])
        // fmt.FprintInt(&w, n * 2)
        d2.Text = "2048"

        table.Render(&p)

        s.Select(nil, nil)
        n++
    }
}
