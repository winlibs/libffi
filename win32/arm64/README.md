# MSVC ARM64 build

Run from an ARM64-targeting Visual Studio developer prompt:

```bat
msbuild win32\arm64\libffi.vcxproj /p:Configuration=Release;Platform=ARM64;PlatformToolset=v143
```

Override `PlatformToolset` with `v142` or `v145` and set
`WindowsTargetPlatformVersion` when selecting an installed Windows SDK.
The project uses the portable C sources and Windows ARM64 assembler backend,
and writes `libffi.lib` and `libffi.pdb` under `win32/arm64/ARM64/Release`.
Use `src/aarch64/ffitarget.h` when installing headers.

The Windows-generated `include/ffi.h` in the 3.8.0 tag also needs its ARM64
architecture definition; winlib-builder applies `patches/libffi-arm64.patch`
before building this project and runs call and closure callback tests.
