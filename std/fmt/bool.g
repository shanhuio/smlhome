func FprintBool(w *bytes.Buffer, b bool) {
    if b {
        w.WriteString("true")
    } else {
        w.WriteString("false")
    }
}

func PrintBool(b bool) {
    if b {
        PrintStr("true")
    } else {
        PrintStr("false")
    }
}
