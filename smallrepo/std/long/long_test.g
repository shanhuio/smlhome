func TestUdiv1e9() {
    var lo Long
    lo.Set(0x2, 0x540be400) // 1e10
    lo.Udiv1e9()
    assert(lo.Hi == 0 && lo.Lo == 10)

    lo.Set(0x2, 0x540be3ff) // 1e10 - 1
    lo.Udiv1e9()
    assert(lo.Hi == 0 && lo.Lo == 9)

    lo.Set(0x2, 0x540be401) // 1e10 + 1
    lo.Udiv1e9()
    assert(lo.Hi == 0 && lo.Lo == 10)

    lo.Set(0, 1000000000)
    lo.UmulU16(1)
    assert(lo.Hi == 0 && lo.Lo == 1000000000)
}
