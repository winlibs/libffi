
supports Windows "VS oriented" generators

# Visual Studio 32/64 projects
cmake -G"Visual Studio 16 2019" -A Win32 -DCMAKE_INSTALL_PREFIX=c:/output c:/libffi

# ninja
cmake -GNinja -A Win32 -DCMAKE_INSTALL_PREFIX=c:/output c:/libffi

SHARED_LIB option to generate dll/import library

Unsupported, but not too difficult...
- Msys/Cygwin
- Processing *.in config files
