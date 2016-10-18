func etime() long.Long {
    var ret long.Long
    vpc.TimeElapsed(&ret)
    return ret
}
