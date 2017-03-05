import (
    "canvas"
)

func main() {
    cls := canvas.AllocBoxClass()
    cls.Width = 300
    cls.Height = 30
    cls.Background = 0xffffff
    cls.Foreground = 0x000000
    cls.FontSize = 15
    cls.BorderRadius = 5
    canvas.UpdateBoxClass(cls)

    var ba canvas.BoxArray

    b := canvas.AllocBox()
    b.ClassID = cls.ID()
    b.Left = 75
    b.Top = 100
    b.ZIndex = 1
    b.Text = "Hello, world!"

    ba.Append(b)
    canvas.Render(&ba)

    canvas.FreeBox(b)
    canvas.FreeBoxClass(cls)
}
