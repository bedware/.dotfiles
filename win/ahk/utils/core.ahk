; Yeah, arrays start from 1 in AHK and arr.Length == arr.MaxIndex()
IndexOf(needle, haystack) {
    for i, k in haystack {
        if (k == needle) {
            return i
        }
    }
    return -1
}

GetIfContains(arr, inp) {
    result := false
    for key, value in arr {
        if (key == inp) {
            result := value
            break
        }
    }
    return result
}

