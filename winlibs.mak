!IFNDEF VERSION
VERSION=unknown
!ENDIF

!IF "$(PHP_SDK_ARCH)" == "x64"
PLATFORM=x64
SUBFOLDER=x64
!ELSE
PLATFORM=Win32
SUBFOLDER=
!ENDIF

OUTPUT=$(MAKEDIR)\..\libffi-$(VERSION)-$(PHP_SDK_VS)-$(PHP_SDK_ARCH)
ARCHIVE=$(OUTPUT).zip

all:
	git checkout .
	git clean -fdx

	cd win32\$(PHP_SDK_VS)_$(PHP_SDK_ARCH)
	msbuild libffi-msvc.sln /p:Configuration=Release /p:Platform=$(PLATFORM)

	cd ..\..
	-rmdir /s /q $(OUTPUT)
	xcopy include\ffi.h $(OUTPUT)\include\*
#	sed -i "s/#if defined _MSC_VER && !defined FFI_BUILDING/#if 0 \/*defined _MSC_VER \&\& !defined FFI_BUILDING*\//" $(OUTPUT)\include\ffi.h
	sed -i "s/#define LIBFFI_H/#define LIBFFI_H\n#define FFI_BUILDING/" $(OUTPUT)\include\ffi.h
	xcopy src\x86\ffitarget.h $(OUTPUT)\include\*
	xcopy fficonfig.h $(OUTPUT)\include\*
	xcopy win32\$(PHP_SDK_VS)_$(PHP_SDK_ARCH)\$(SUBFOLDER)\Release\libffi.lib $(OUTPUT)\lib\*
	xcopy win32\$(PHP_SDK_VS)_$(PHP_SDK_ARCH)\libffi\$(SUBFOLDER)\Release\libffi.pdb $(OUTPUT)\lib\*

	del $(ARCHIVE)
	7za a $(ARCHIVE) $(OUTPUT)\*
