var theRand Rand

func SysSeed() {
    theRand.RandInit()
}

func Seed(seed uint) {
    theRand.Init(seed)
}

func Uint() uint {
    return theRand.Uint()
}

func Int() int {
    return theRand.Int()
}

func IntN(n int) int {
    return theRand.IntN(n)
}
