import (
    "terminal"
)

func main() {
    terminal.Resize(3, 20)
    terminal.PrintAt(0, 0, 'x')
    terminal.PrintStr("something here")
}
