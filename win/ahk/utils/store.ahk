; MsgBox % "From Store!"
store := {}

toStore(name, winId) {
    global store
    store[name] := winId
    ; MsgBox % JSON.Dump(store)
}

fromStore(name) {
    global store
    ; MsgBox % JSON.Dump(store)
    if (GetIfContains(store, name)) {
        return store[name]
    }
    return false
}

