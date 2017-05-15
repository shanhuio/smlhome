const packetHeaderLen = 16

const (
    PortDialog = 1001
    PortScreen = 1002
)

struct Packet {
    buf []byte
}

struct PacketHeader {
    Dest uint32
    Src uint32
    DestPort uint32
    SrcPort uint32
}

func (p *Packet) Init(buf []byte) {
    p.buf = buf
}

func (p *Packet) Payload() []byte {
    return p.buf[packetHeaderLen:]
}

func (p *Packet) PayloadBuffer(buf *bytes.Buffer) {
    buf.Init(p.Payload())
}

func (p *Packet) PayloadCoder(coder *coder.Encoder) {
    coder.Init(p.Payload())
}

func (p *Packet) SetHeader(h *PacketHeader, n int) {
    var w coder.Encoder
    w.Init(p.buf[:packetHeaderLen])
    w.U16(0)
    w.U16B(uint32(packetHeaderLen + n))
    w.U32B(h.Dest)
    w.U32B(h.Src)
    w.U16B(h.DestPort)
    w.U16B(h.SrcPort)
}

func Send(p *Packet, n int) int {
    return sendPacket(p.buf[:packetHeaderLen + n])
}
