func Update(crc uint32, tab *Table, p []byte) uint32 {
    tab.build()

    crc = ^crc
    n := len(p)
    for i := 0; i < n; i++ {
        v := p[i]
        crc = tab.d[byte(crc) ^ v] ^ (crc >> 8)
    }
    return ^crc
}

func Checksum(tab *Table, p []byte) uint32 {
    return Update(0, tab, p)
}
