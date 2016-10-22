var (
    configs [nlevel]config
    levels [nlevel]game
)

func main() {
    fmt.PrintStr("Mem pair\n")

    configs[0].setupFunc = easySetup
    for i := 0; i < len(levels); i++ {
        levels[i].setConfig(&configs[i])
    }

    var picker levelPicker
    for {
        level := picker.pick()

        levels[level].run()

        // wait for a click
        var s selector
        s.Select(nil, nil)
    }
}
