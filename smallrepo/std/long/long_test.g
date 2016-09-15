func TestUdiv1e9() {
	var lo Long
	lo.Set(0x2, 0x540be400)
	lo.Udiv1e9()
	printUint(lo.Lo)
	assert(lo.Hi == 0 && lo.Lo == 10)

	lo.Set(0x2, 0x540be3ff)
	lo.Udiv1e9()
	printUint(lo.Lo)
	assert(lo.Hi == 0 && lo.Lo == 9)
}
