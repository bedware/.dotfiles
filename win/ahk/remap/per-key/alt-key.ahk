#if HOTKEYS_ON && GetKeyState("LAlt", "P")
    ; *1::F1
    ; *2::F2
    ; *3::F3
    ; *4::F4
    ; *5::F5
    ; *6::F6
    ; *7::F7
    ; *8::F8
    ; *9::F9
    ; *0::F10
    ; *t::F11
    ; *y::F12
    ; *-::F11
    ; *=::F12

    *Tab::return

    6::Send !{Tab}
    ; *q::closeWindow()

    ; Copy & Paste
    c::Send ^{Insert}
    v::Send +{Insert}
#if
#if HOTKEYS_ON && GetKeyState("LAlt", "P") && ScopeIs("ahk_exe WindowsTerminal.exe")
    *1::^!1
    *2::^!2
    *3::^!3
    *4::^!4
    *5::^!5
    *6::^!6
    *7::^!7
    *8::^!8
    *9::^!9
#if
