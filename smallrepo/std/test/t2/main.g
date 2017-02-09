import (
    "canvas"
)

func main() {
    c := canvas.Get()

    cls := c.AllocBoxClass()
    cls.Width = 300
    cls.Height = 30
    cls.Background = 0xffffff
    cls.Foreground = 0x000000
    cls.FontSize = 15
    cls.BorderRadius = 5
    canvas.UpdateBoxClass(cls)

    var ba canvas.BoxArray

    b := c.AllocBox()
    b.ClassID = cls.ID()
    b.Left = 100
    b.Top = 100
    b.Text = "Hello, world!"

    ba.Append(b)
    c.Render(&ba)

    c.FreeBox(b)
    c.FreeBoxClass(cls)
}
