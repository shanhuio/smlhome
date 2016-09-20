const (
    xoffset = 5
    yoffset = 20
    xgrid = 2
    ygrid = 4
)

func translateClick(x, y int) (int, bool) {
    if x < xoffset return 0, false
    if y < yoffset return 0, false
    x -= xoffset
    y -= yoffset
    if x % xgrid != 0 return 0, false
    if y % ygrid != 0 return 0, false
    x /= xgrid
    y /= ygrid
    if x >= width return 0, false
    if y >= height return 0, false
    return x * height + y, true
}

func drawMessage(s string) {
    for i := 0; i < 50; i++ {
        screen.PrintAt(xoffset - 2, yoffset + i, ' ')
    }
    screen.PrintStrAt(xoffset - 2, yoffset, s)
}

func drawStats(bs []byte) {
    for i := 0; i < 50; i++ {
        screen.PrintAt(xoffset + 10, yoffset + i, ' ')
    }
    for i := 0; i < len(bs); i++ {
        screen.PrintAt(xoffset + 10, yoffset + i, char(bs[i]))
    }
}

