import (
    "canvas"
)

func main() {
    c := canvas.Get()
    var ba canvas.BoxArray

    b := c.AllocBox()
    b.Left = 100
    b.Top = 100
    b.Text = "Hello, world!"

    ba.Append(b)
    c.Render(&ba)
}
