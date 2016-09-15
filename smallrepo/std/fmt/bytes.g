func PrintBytes(bs []byte) {
	for i := 0; i < len(bs); i++ {
		PrintChar(char(bs[i]))
	}
}
