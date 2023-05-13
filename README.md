# Obfuscated-Nim-Reverse-Shell
Obfuscated Nim Reverse Shell. Bypasses Windows Defender, and I mean completely laughs at it. 
This works on both Linux and Windows victims!
# Compiling for Windows
`nim c --stacktrace:off -d:mingw filename.nim`
# Compiling for Mac (Still needs further testing)
`nim c -d:x86_64-w64-mingw32-gcc filename.nim`
# Compiling for Linux
`Still need to add this`
# Stripping 
`strip -s filename.exe`
