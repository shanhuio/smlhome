import (
    "vpc"
    "encoding/binary"
)

// Rand generates a random uint32.
func Rand() uint32 {
    var resp [4]byte
    n, err := vpc.Call(vpc.Rand, nil, resp[:])
    if err != 0 {
        panic()
    }
    if n != 4 {
        panic()
    }

    return binary.U32(resp[:])
}

func TestRand() {
    a := Rand()
    b := Rand()
    assert(a != b)
}
