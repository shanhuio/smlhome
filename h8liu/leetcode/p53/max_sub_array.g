// MaxSubArray returns the contiguous subarray of array dat that has the
// largest sum.
func MaxSubArray(dat []int) int {
    max := 0
    sum := 0
    for i := 0; i < len(dat); i++ {
        sum += dat[i]
        if sum < 0 {
            sum = 0
        }
        if sum > max {
            max = sum
        }
    }

    return max
}

func TestMaxSubArray() {
    assert(MaxSubArray([]int{-2, 1, -3, 4, -1, 2, 1, -5, 4}) == 6)

    assert(MaxSubArray([]int{}) == 0)
    assert(MaxSubArray([]int{1}) == 1)
    assert(MaxSubArray([]int{-1}) == 0)
    assert(MaxSubArray([]int{-1, 1, 2, -3}) == 3)
    assert(MaxSubArray([]int{-1, 3, -1, 2, -3}) == 4)
}
