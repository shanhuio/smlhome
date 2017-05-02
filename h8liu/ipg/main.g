import (
    "rand"
    "canvas"
    "events"
)

var qs [100]string

var nq int

func o(s string) {
    qs[nq] = s
    nq++
}

func init() {
    o("What is your product?")
    o("Who needs your product?")
    o("Where is the market?")
    o("Why you?")
    o("What are people doing now?")
    o("What is your core tech?")
    o("Why isn't someone doing this?")
    o("Why did you choose this idea?")
    o("What are you going to do?")
    o("Where are you now?")
    o("How will customers find you?")
    o("How will you make money?")
    o("How will you make a cut from apps?")
    o("How about GUI stuff?")
    o("If you succeed, is there more?")
    o("What is your mission?")
    o("What have you learned?")
    o("How do you resolve disagreements?")
    o("Why new language?")
    o("Does the 300-line thing really work?")
    o("How will you overcome the resistance?")
    o("What if you are not flying in 6 months?")
    o("How will you penetrate the entrance barrier?")
    o("How will you compete with cloud providers?")
    o("How to make money with development tools?")
}

func main() {
    cls := canvas.AllocBoxClass()
    cls.Width = 430
    cls.Height = 100
    cls.Background = 0xffffff
    cls.BorderRadius = 5
    cls.FontSize = 18
    canvas.UpdateBoxClass(cls)

    box := canvas.AllocBox()
    box.ClassID = cls.ID()
    box.Left = 10
    box.Top = 150

    var array canvas.BoxArray
    array.Append(box)

    rand.SysSeed()

    var s events.Selector

    last := -1
    for {
        pick := last
        for {
            pick = rand.IntN(nq)
            if pick != last break
        }

        box.Text = qs[pick]
        canvas.Render(&array)

        last = pick

        for {
            ev := s.Select(nil, nil)
            if ev == events.KeyDown || ev == events.Click break
        }
    }
}
