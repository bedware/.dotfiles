ProcessExist(exeName) {
    Process, Exist, %exeName%
    return ErrorLevel
}

RunIfProcessNotExist(exeName, path) {
    if (!ProcessExist(exeName)) {
        Run %path%
        return ProcessExist(exeName) 
    }
    return 0
}

