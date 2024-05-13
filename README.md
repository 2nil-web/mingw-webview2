# PoC: WebView2 in MinGW

A fork from this repository : [GitHub - jchv/webview2-in-mingw](https://github.com/jchv/webview2-in-mingw.git)

Added an icon, simplified the build and added a parameter to view any web site or html file.

## Usage

Simply compile with a MinGW toolchain. Msys2 + MinGW64 should work fine. Run make:

```
make
```

and if it works, you will have webview2-mingw.exe in your working directory eventually with a parameter poiting to a web site or html file.
