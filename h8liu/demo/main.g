import (
    "fmt"
    "canvas"
    "events"
    "keycode"
)

func printHello() {
    fmt.PrintStr("Let's build a small app!\n")
}

var boxArray canvas.BoxArray

func main() {
    cls1 := canvas.AllocBoxClass()
    cls1.Width = 150
    cls1.Height = 150
    cls1.BorderRadius = 10
    cls1.Background = 0xffffff
    cls1.Foreground = 0x990000
    cls1.FontSize = 20

    cls2 := canvas.AllocBoxClass()
    cls2.Width = 150
    cls2.Height = 150
    cls2.BorderRadius = 10
    cls2.Background = 0xcccccc
    cls2.Foreground = 0x009900
    cls2.FontSize = 20

    canvas.UpdateBoxClass(cls1)
    canvas.UpdateBoxClass(cls2)

    b1 := canvas.AllocBox()

    b1.ClassID = cls1.ID()
    b1.Left = 100
    b1.Top = 100
    b1.Text = "Hello, world!"
    b1.ZIndex = 1

    b2 := canvas.AllocBox()
    b2.ClassID = cls2.ID()
    b2.Left = 50
    b2.Top = 50
    b2.Text = "Something"
    b2.ZIndex = 2

    boxArray.Append(b1)
    boxArray.Append(b2)
    canvas.Render(&boxArray)

    var msg string
    var s events.Selector
    for {
        ev := s.Select(nil, nil)
        if ev == events.KeyDown {
            key := s.LastKeyCode()
            if key == keycode.Up {
                msg = "Up"
            } else if key == keycode.Down {
                msg = "Down"
            } else if key == keycode.Left {
                msg = "Left"
            } else if key == keycode.Right {
                msg = "Right"
            } else {
                msg = "X"
            }

            b2.Text = msg
            canvas.Render(&boxArray)
        }
    }
    // printHello()
}
