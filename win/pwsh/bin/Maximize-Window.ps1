Add-Type @"
using System;
using System.Runtime.InteropServices;
public class Win32 {
    [DllImport("user32.dll")]
    [return: MarshalAs(UnmanagedType.Bool)]
    public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);
    [DllImport("user32.dll")]
    public static extern IntPtr GetForegroundWindow();
    [DllImport("user32.dll")]
    public static extern bool GetWindowPlacement(IntPtr hWnd, [In, Out] ref WINDOWPLACEMENT lpwndpl);
    [StructLayout(LayoutKind.Sequential)]
    public struct WINDOWPLACEMENT {
        public int length;
        public int flags;
        public int showCmd;
        public POINT ptMinPosition;
        public POINT ptMaxPosition;
        public RECT rcNormalPosition;
    }
    [StructLayout(LayoutKind.Sequential)]
    public struct POINT {
        public int x;
        public int y;
    }
    [StructLayout(LayoutKind.Sequential)]
    public struct RECT {
        public int left;
        public int top;
        public int right;
        public int bottom;
    }
}
"@
$hwnd = [Win32]::GetForegroundWindow()
$placement = New-Object Win32+WINDOWPLACEMENT
$placement.length = [System.Runtime.InteropServices.Marshal]::SizeOf($placement)
[Win32]::GetWindowPlacement($hwnd, [ref]$placement)
if ($placement.showCmd -eq 3) {
    # 3 is SW_MAXIMIZE
    [Win32]::ShowWindow($hwnd, 9)  # 9 is SW_RESTORE
} else {
    [Win32]::ShowWindow($hwnd, 3)  # 3 is SW_MAXIMIZE
}

