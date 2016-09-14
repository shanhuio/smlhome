const screenPage = 4096 * 5

func PrintAt(x, y int, ch char) {
    var buf [4]byte
    buf[1] = byte(ch)
    buf[2] = byte(x)
    buf[3] = byte(y)

    _, code := vpc.Call(vpc.Screen, buf[:], nil)
    if code != 0 {
        panic()
    }
}

// PrintStrAt prints a string at a particular position on the screen.
func PrintStrAt(x, y int, s string) {
    for i := 0; i < len(s); i++ {
        PrintAt(x, y + i, s[i])
    }
}
