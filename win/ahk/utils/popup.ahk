; Creating popups

createPopUp(title, pwshCommand, centered := true, maximized := false) {
    if (!RemoveAppFromTrayByTitle(title)) {
        Run, % "C:\Program Files\Alacritty\alacritty.exe" 
            . " --title """ title """"
            . " -o window.decorations=None"
            . " -o window.opacity=1.0"
            . " -o window.position.x=1000"
            . " -o window.position.y=250"
            . " -o window.dimensions.lines=25"
            . " -o window.dimensions.columns=35"
            . " --command pwsh -nop -nologo -c """ pwshCommand """"
        WinWait, %title% ahk_class Window Class ahk_exe alacritty.exe,, 5
        WinActivate ; Use the window found by WinWait.

        Sleep 100
        if (centered)
            makeAnyWindowUpperCentered()
        if (maximized)
            makeAnyWindowMaximized()
    }
}

