func i2a(bs []byte, i int) string {
    var buf bytes.Buffer
    buf.Init(bs)

    fmt.FprintInt(&buf, i)
    return buf.String()
}
