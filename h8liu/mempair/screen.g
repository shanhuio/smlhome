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

func drawString(x, y int, s string, w int) {
    n := len(s)
    for i := 0; i < w; i++ {
        if i < n {
            screen.PrintAt(x, y + i, s[i])
        } else {
            screen.PrintAt(x, y + i, ' ')
        }
    }
}

func drawBytes(x, y int, bs []byte, w int) {
    n := len(bs)
    for i := 0; i < w; i++ {
        if i < n {
            screen.PrintAt(x, y + i, char(bs[i]))
        } else {
            screen.PrintAt(x, y + i, ' ')
        }
    }
}

func drawMessage(s string) {
    drawString(xoffset - 2, yoffset, s, 50)
    table.SetText(0, s)
}

func drawStats(bs []byte) {
    drawBytes(xoffset + 10, yoffset, bs, 20)
    table.SetTextBytes(1, bs)
}

func drawTime(t int) {
    var buf [20]byte
    var line bytes.Buffer
    line.Init(buf[:])
    fmt.FprintInt(&line, t)
    line.WriteString(" sec")

    bs := line.Bytes()
    drawBytes(xoffset + 11, yoffset, bs, 20)
    table.SetTextBytes(3, bs)
}
