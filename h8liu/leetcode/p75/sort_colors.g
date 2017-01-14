// SortColors sorts an array of 0, 1 or 2.
func SortColors(nums []int) {
    count0 := 0
    count1 := 0
    for i := 0; i < len(nums); i++ {
        cur := nums[i]
        if cur == 0 {
            count0++
        } else if cur == 1 {
            count1++
        }
    }

    for i := 0; i < count0; i++ {
        nums[i] = 0
    }
    for i := count0; i < count0 + count1; i++ {
        nums[i] = 1
    }
    for i := count0 + count1; i < len(nums); i++ {
        nums[i] = 2
    }
}

func deepEqual(a, b []int) bool {
    if len(a) != len(b) return false
    for i := 0; i < len(a); i++ {
        if a[i] != b[i] return false
    }
    return true
}

func check(buffer, expect []int) {
    SortColors(buffer)
    assert(deepEqual(buffer, expect))
}

func TestSortColors() {
    check([]int{}, []int{})
    check([]int{0}, []int{0})
    check([]int{1}, []int{1})
    check([]int{1, 2}, []int{1, 2})
    check([]int{2, 1}, []int{1, 2})
    check([]int{2, 2, 2, 1, 1, 1, 0, 0}, []int{0, 0, 1, 1, 1, 2, 2, 2})
    check([]int{2, 1, 0, 2, 1, 0, 1, 2}, []int{0, 0, 1, 1, 1, 2, 2, 2})
}
