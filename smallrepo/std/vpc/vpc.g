struct control {
    control uint8
    padding [3]uint8

    service uint32

    reqAddr uint32
    reqLen int32
    respAddr uint32
    respSize int32

    respCode int32
    respLen int32
}

const (
    // MaxLen is the maximum message length.
    MaxLen = 1500
)

var vpc *control

func init() {
    const page = 4096 * 3
    vpc = (*control)(uint(page))
}

// Call performs a VPC call.
func Call(s uint, req, resp []byte) (n int, err int) {
    vpc.service = s
    if req != nil {
        vpc.reqAddr = uint(&req[0])
        vpc.reqLen = len(req)
    } else {
        vpc.reqAddr = 0
        vpc.reqLen = 0
    }

    if resp != nil {
        vpc.respAddr = uint(&resp[0])
        vpc.respSize = len(resp)
    } else {
        vpc.respAddr = 0
        vpc.respSize = 0
    }

    vpc.control = 1

    iocall()

    code := vpc.respCode
    if code != 0 {
        return 0, code
    }
    return vpc.respLen, 0
}

// Poll polls for incoming messages.
func Poll(waitNanos *long.Long, msg []byte) (s uint, n int, err int) {
    if waitNanos != nil {
        var buf [8]byte // duration in nanosecond
        waitNanos.ToWire(buf[:])
        vpc.reqAddr = uint(&buf[0])
        vpc.reqLen = len(buf)
    } else {
        vpc.reqLen = 0
    }

    vpc.respAddr = uint(&msg[0])
    vpc.respSize = len(msg)
    vpc.service = 0
    vpc.control = 1

    iocall()

    code := vpc.respCode
    if code != 0 {
        return 0, vpc.respLen, code
    }
    return vpc.service, vpc.respLen, 0
}
