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

    boxClassUpdate = 16
    boxUpdate = 17
    boxShow = 18 // using a mask
)

func sendCommit() {
    var enc coder.Encoder
    p := prepare()
    p.PayloadCoder(&enc)
    enc.U8(0)
    call(p, enc.Len())
}
