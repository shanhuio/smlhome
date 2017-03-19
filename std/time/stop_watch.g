struct StopWatch {
    start long.Long
}

func (w *StopWatch) Start() {
    w.start = Now()
}

func (w *StopWatch) PrintUs() {
    t := Now()
    t.Sub(&w.start)
    t.UdivU16(1000)
    fmt.PrintInt(t.Ival())
    fmt.Println()
}

func (w *StopWatch) Read() long.Long {
    t := Now()
    t.Sub(&w.start)
    return t
}
