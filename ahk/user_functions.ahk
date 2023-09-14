RearrangeWindows() {
    global apps
    global desktops
    for i, v in apps {
        if (v.desktop != "" && v.selector != "") {
            moved := false
            while (WinExist(v.selector) and !moved) {
                WinActivate 
                desktopNum := IndexOf(v.desktop, desktops)
                if (IndexOf(v.desktop, desktops) != -1) {
                    MoveCurrentWindowToDesktop(desktopNum - 1)
                    moved = true
                }
            }
        }
    } 
}

screencastProfile() {
    init := {}
    ; init["Screen share"] := { exe: "duet.exe", path: "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\duet.lnk" }
    ; init["Camera"] := { exe: "iVCam.exe", path: "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\e2eSoft iVCam\iVCam.lnk" }
    ; init["OBS"] := { exe: "obs64.exe", path: apps["obs"].path, moveToMonitorNumber: 2, maximize: true, showOnAllDesktops: true }
    ; init["Task Manager"] := { exe: "Taskmgr.exe", path: "Taskmgr.exe", moveToMonitorNumber: 2, maximize: true, showOnAllDesktops: true }
    init["OBS"] := { exe: "obs64.exe", path: apps["obs"].path, maximize: true }
    init["Task Manager"] := { exe: "Taskmgr.exe", path: "Taskmgr.exe",  maximize: true }
    ; Run
    for index, app in init {
        if (app.exe and app.path) {
            RunIfProcessNotExist(app.exe, app.path)
        }
        ; Configure
        if (app.moveToMonitorNumber or app.maximize or app.showOnAllDesktops or app.sleepy) {
            selector := "ahk_exe " app.exe

            WinWait, %selector%,, 5
            if WinExist(selector) {
                WinActivate
                if (app.moveToMonitorNumber == 2) {
                    WinRestore
                    WinMove,,, 1000, 3000, 500, 500
                    ; Sleep 50
                }
                if (app.maximize) {
                    WinMinimize
                    ; Sleep 150
                    WinMaximize
                }
                if (app.showOnAllDesktops) {
                    WinGet, activeHwnd, ID, A
                    PinWindow(activeHwnd)
                }
            }
        }
    }
    ; Post action
    if WinExist("ahk_exe iVCam.exe") {
        WinClose
    }
}

