struct Table {
    poly uint32
    built bool

    d [256]uint32
}

func (t *Table) Init(poly uint32) {
    t.poly = poly
    t.built = false
}

func (t *Table) build() {
    if t.built return

    poly := t.poly
    for i := uint32(0); i < 256; i++ {
        crc := i
        for j := 0; j < 8; j++ {
            if crc & 1 == 1 {
                crc = (crc >> 1) ^ poly
            } else {
                crc >>= 1
            }
            t.d[i] = crc
        }
    }
    t.built = true
}
