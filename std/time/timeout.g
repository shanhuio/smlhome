struct Timeout {
    valid bool
    t long.Long
    ret long.Long
}

func (t *Timeout) Clear() {
    t.valid = false
}

func (t *Timeout) Set(in *long.Long) bool {
    if !t.valid {
        t.valid = true
        t.t = *in
        return true
    }

    if in.LargerThan(&t.t) return false
    t.t = *in
    return true
}

func (t *Timeout) Get(now *long.Long) *long.Long {
    if !t.valid return nil

    ret := &t.ret
    if t.t.LargerThan(now) {
        *ret = t.t
        ret.Sub(now)
    } else {
        ret.Clear()
    }
    return ret
}
