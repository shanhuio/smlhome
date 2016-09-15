struct Time {
    ts long.Long
}

func (t *Time) Set(nanos *long.Long) {
    t.ts = *nanos
}

func (t *Time) Print() {
    printUint(t.ts.Hi)
    printUint(t.ts.Lo)
}

func (t *Time) ToWire(buf []byte) {
    t.ToWire(buf)
}
