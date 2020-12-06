cmake_minimum_required(VERSION 3.5)
project(libffi C ASM_MASM)

set(libname "libffi")

option(BUILD_SHARED_LIBS "Build shared libraries" ON)

if (BUILD_SHARED_LIBS)
    add_library(${libname} SHARED)
else()
    add_library(${libname})
endif (BUILD_SHARED_LIBS)

list(APPEND include_dirs
    "." # fficonfig.h
    "include"
    "src/x86"
    )

# option version of includes
foreach(dd ${include_dirs})
    list(APPEND include_opts "-I" "${CMAKE_SOURCE_DIR}/${dd}")
endforeach()

# select sources by platform
if("${CMAKE_SIZEOF_VOID_P}" STREQUAL "4")
    # Windows 32
    list(APPEND asm_basenames "sysv_intel")
    target_sources(${libname} PRIVATE
        "src/x86/ffi.c"
        "src/x86/internal.h"
        )
else()
    # Windows 64
    list(APPEND asm_basenames "win64_intel")
    target_sources(${libname} PRIVATE
        "src/x86/ffiw64.c"
        "src/x86/internal64.h"
    )
endif()

# preprocess assembly files
foreach(ff ${asm_basenames})
    # compose assembly file names
    set(f_S "${CMAKE_SOURCE_DIR}/src/x86/${ff}.S")
    set(f_asm "${CMAKE_CURRENT_BINARY_DIR}/${ff}.asm")

    # S -> asm
    add_custom_command(
        OUTPUT ${f_asm}
        COMMAND ${CMAKE_C_COMPILER}
        ARGS ${CMAKE_CPP_FLAGS} ${include_opts} -EP ${f_S} > ${f_asm}
        DEPENDS "${f_S}"
        COMMENT "C preprocessor"
        )

    # add asm to compile list
    set_source_files_properties(${f_asm} PROPERTIES GENERATED TRUE)
    set_source_files_properties(${f_asm} PROPERTIES COMPILE_FLAGS -safeseh)
    target_sources(${libname} PRIVATE ${f_asm})
endforeach()

target_sources(${libname} PRIVATE
    # generated from *.in
    "fficonfig.h"
    "include/ffi.h"

    # common source files
    "src/closures.c"
    "src/prep_cif.c"
    "src/raw_api.c"
    "src/types.c"
    "src/x86/ffitarget.h"
    )
target_compile_definitions(${libname} PRIVATE "FFI_BUILDING")
target_include_directories(${libname} PRIVATE ${include_dirs})

if (BUILD_SHARED_LIBS)
    # export all funtions for DLL
    set_target_properties(${libname} PROPERTIES WINDOWS_EXPORT_ALL_SYMBOLS ON)
endif()

# install the lib
install(TARGETS ${libname}
    LIBRARY DESTINATION lib
    ARCHIVE DESTINATION lib
    RUNTIME DESTINATION bin
    )

# install the headers
install(
    FILES include/ffi.h src/x86/ffitarget.h
    DESTINATION include
    )
