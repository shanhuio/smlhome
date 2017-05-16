var msgBuf [1300]byte

var msgPacket vpc.Packet

func prepare() *vpc.Packet {
    p := &msgPacket
    p.Init(msgBuf[:])
    return p
}

func call(p *vpc.Packet, n int) {
    var h vpc.PacketHeader
    h.DestPort = vpc.PortTable
    p.SetHeader(&h, n)
    vpc.Send(p, n)
}

const (
    commit = 0

    cardShow = 1
    cardShowFront = 2
    cardShowBack = 3
    cardHide = 4
    cardHideFront = 5
    cardHideBack = 6
    cardFace = 7

    labelText = 8

    buttonShow = 9
    buttonHide = 10
    buttonText = 11

    picShow = 12
    picHide = 13
    picPosition = 14

    divUpdate = 15

    boxClassUpdate = 16
    boxUpdate = 17
    boxShow = 18
)

func actCommit() {
    var enc coder.Encoder
    p := prepare()
    p.PayloadCoder(&enc)
    enc.U8(0)
    call(p, enc.Len())
}

func act(action, pos uint8) {
    actChar(action, pos, char(0))
}

func actChar(action, pos uint8, face char) {
    var enc coder.Encoder
    p := prepare()
    p.PayloadCoder(&enc)
    enc.U8(action)
    enc.U8(pos)
    enc.U8(uint8(face))
    enc.Pad(1)
    call(p, enc.Len())
}

func actNums(action uint8, n1, n2 int) {
    var enc coder.Encoder
    p := prepare()
    p.PayloadCoder(&enc)
    enc.U8(action)
    enc.U8(0)
    enc.I32(n1)
    enc.I32(n2)
    call(p, enc.Len())
}

func actString(action, pos uint8, s string) {
    var enc coder.Encoder
    p := prepare()
    p.PayloadCoder(&enc)
    enc.U8(action)
    enc.U8(pos)
    enc.U8(uint8(len(s)))
    enc.Str(s)
    call(p, enc.Len())
}

func actBytes(action, pos uint8, bs []byte) {
    var enc coder.Encoder
    p := prepare()
    p.PayloadCoder(&enc)
    enc.U8(action)
    enc.U8(pos)
    enc.U8(uint8(len(bs)))
    enc.Write(bs)
    call(p, enc.Len())
}
