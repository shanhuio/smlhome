var msgBuf [1300]byte

func call(buf []byte) {
    _, err := vpc.Call(vpc.Table, buf, nil)
    if err != 0 {
        printInt(err)
        panic()
    }
}

const (
    commit = 0

    boxClassUpdate = 16
    boxUpdate = 17
    boxShow = 18 // using a mask
)

func sendCommit() {
    buf := msgBuf[:1]
    buf[0] = 0
    call(buf)
}
