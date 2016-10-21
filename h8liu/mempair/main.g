var levels [8]game

func main() {
    fmt.PrintStr("Mem pair\n")

    var picker levelPicker
    for {
        level := picker.pick()

        levels[level].run()

        // wait for a click
        var s selector
        s.Select(nil, nil)
    }
}
