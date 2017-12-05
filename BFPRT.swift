//https://en.wikipedia.org/wiki/Median_of_medians

func qselect(arr: inout [Int], left: Int, right: Int, n: Int ) -> Int{
    var left = left
    var right = right
    
    if left == right {
        return left
    }
    var pivotIndex = pivot(arr: &arr, left: left, right: right)
    pivotIndex = partition(arr: &arr, left: left, right: right, pivotIndex: pivotIndex)
    
    if n == pivotIndex {
        return n
    }else if n < pivotIndex {
        right = pivotIndex - 1
    }else {
        left = pivotIndex + 1
    }
    return qselect(arr: &arr, left: left, right: right, n: n)
}
func pivot(arr: inout [Int], left: Int, right: Int ) -> Int {
    if right - left < 5 {
        return insertSort(arr: &arr, left: left, right: right)
    }
    for i in stride(from: left, to: right , by: 5){
        let subRight = min(i + 4, right) b
       
        let median5 = insertSort(arr: &arr, left: i, right: subRight)
        
        arr.swapAt(left +  (i - left ) / 5, median5)
    }
    let newRight = left + Int( ceil( Double( right - left ) / 5 ) - 1 )
    let newn = left + (right - left  ) / 10
    return qselect(arr: &arr, left: left, right: newRight, n: newn)
}

func partition(arr: inout [Int], left: Int, right: Int, pivotIndex: Int) -> Int {
    let pivotValue = arr[pivotIndex]
    arr.swapAt(pivotIndex, right)
    var storeIndex = left
    for i in left...(right-1){
        if arr[i] < pivotValue {
            arr.swapAt(storeIndex, i)
            storeIndex += 1
        }
    }
    arr.swapAt(storeIndex, right)
    return storeIndex
}

func insertSort(arr: inout [Int], left: Int , right: Int) -> Int {
    for i in (left+1)...right {
        for j in stride(from: i, to: left, by: -1){
            if arr[j] < arr[j - 1]{
                arr.swapAt(j, j - 1)
            }else {
                break
            }
        }
    }
    return left + ( (right - left ) >> 1)
}