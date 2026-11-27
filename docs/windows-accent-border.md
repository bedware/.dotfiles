# Removing the accent-colored window border on Windows 11

## What it is

With **Settings → Personalization → Colors → "Show accent color on title bars and
window borders"** turned on (registry `HKCU\Software\Microsoft\Windows\DWM\ColorPrevalence = 1`),
DWM paints a 1px border in the accent color (blue) around every top-level window it
frames — including Electron `frame: false` windows and popups. macOS has no
equivalent, so the same UI looks different on Windows.

The border is drawn by DWM, not by the app, so CSS can't hide it. It is controlled per
window with `DwmSetWindowAttribute` (Windows 11 build 22000+; older Windows ignores
it — harmless):

| Attribute | Id | Value | Effect |
|---|---|---|---|
| `DWMWA_BORDER_COLOR` | 34 | `0xFFFFFFFE` (`DWMWA_COLOR_NONE`) | no border at all |
| `DWMWA_BORDER_COLOR` | 34 | `0x00BBGGRR` | border in that color (e.g. the app's bg) |
| `DWMWA_BORDER_COLOR` | 34 | `0xFFFFFFFF` (`DWMWA_COLOR_DEFAULT`) | back to system (accent) |
| `DWMWA_CAPTION_COLOR` | 35 | `0x00BBGGRR` | title bar fill (framed windows only) |

`COLORREF` is **BGR**: `#282828` → `0x00282828`, `#fbf1c7` → `0x00C7F1FB`.

Shadow and rounded corners are kept — only the 1px line goes away.

## Electron recipe

Call it once the window exists (and again is harmless), on Windows only:

```ts
// main process
if (process.platform === 'win32') {
  win.once('ready-to-show', () => removeWindowBorder(win))
}
```

`win.getNativeWindowHandle()` returns a Buffer holding the HWND (8 bytes on x64,
read with `buf.readBigUInt64LE(0)`).

### Option A — app already has a Rust napi module (Runwa)

`native/Cargo.toml` (windows crate):

```toml
[target.'cfg(windows)'.dependencies]
windows = { version = "0.58", features = ["Win32_Foundation", "Win32_Graphics_Dwm"] }
```

```rust
#[cfg(windows)]
#[napi]
pub fn remove_window_border(hwnd: napi::bindgen_prelude::BigInt) -> napi::Result<()> {
    use windows::Win32::{Foundation::HWND, Graphics::Dwm::{DwmSetWindowAttribute, DWMWA_BORDER_COLOR}};
    let (_, value, _) = hwnd.get_u64();
    let color: u32 = 0xFFFF_FFFE; // DWMWA_COLOR_NONE
    unsafe {
        DwmSetWindowAttribute(
            HWND(value as isize as _),
            DWMWA_BORDER_COLOR,
            &color as *const u32 as *const _,
            std::mem::size_of::<u32>() as u32,
        )
    }
    .map_err(|e| napi::Error::from_reason(e.to_string()))
}
```

```ts
removeWindowBorder(win) // -> native.removeWindowBorder(win.getNativeWindowHandle().readBigUInt64LE(0))
```

### Option B — no Windows native module (Vimperium): FFI with `koffi`

```ts
import koffi from 'koffi'

const dwmapi = process.platform === 'win32' ? koffi.load('dwmapi.dll') : null
const DwmSetWindowAttribute = dwmapi?.func(
  'long __stdcall DwmSetWindowAttribute(void *hwnd, uint32 attr, _In_ uint32 *value, uint32 size)'
)

export function removeWindowBorder(win: Electron.BrowserWindow): void {
  if (!DwmSetWindowAttribute) return
  const hwnd = koffi.as(win.getNativeWindowHandle(), 'void *') // Buffer -> pointer value
  DwmSetWindowAttribute(hwnd, 34 /* DWMWA_BORDER_COLOR */, [0xfffffffe /* NONE */], 4)
}
```

(If `koffi.as` on the Buffer is awkward, decode the HWND with
`readBigUInt64LE(0)` and pass it as `uintptr`.)

## Notes

- Apply it to **every** framed or `frame: false` window: main windows, popups, toasts,
  dropdowns. Windows created with `transparent: true` usually have no DWM frame,
  but check them too.
- Don't use `thickFrame: false` for this: it does remove the border, but also the
  shadow, rounded corners and Snap.
- Verify with the accent setting ON (that's when the bug shows).
- Same fix in Ghostty for Windows: `src/apprt/win32/Window.zig` `updateTheme()`
  sets `DWMWA_BORDER_COLOR = DWMWA_COLOR_NONE` when the caption is tinted
  (`window-theme = ghostty`).
