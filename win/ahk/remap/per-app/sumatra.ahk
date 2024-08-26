#if ScopeIs("ahk_exe SumatraPDF.exe")
    b::Send ^8

    s::
    p::
        Send ^6
    return
#if

#if ScopeIs("ahk_exe SumatraPDF.exe") and HYPER_PRESSED
    a::Send ^+k
#if
