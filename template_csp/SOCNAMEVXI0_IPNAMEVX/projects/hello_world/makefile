PROJECT_NAME=demo_cryptolib

# Args for python script
	RUN_ARGS=1

# Loader options
	#JTAG frequency in Hz: download time decrease up to 2MHz, no use to go beyond that
	#If you have download failures, reduce it (and let us know)
	TPOLDR_FREQ=2000000
	TPOLDR_VERBOSE=1

# Compiler options
	# DEBUG: set to 1 or 0. 
	#If set to "none" then optimization level is not set and TPO_GDB_DEBUG is not defined
	#If you prefer to choose this via GUI, put the define in each configuration accordingly
	DEBUG?=0
	
	# CFLAGS
	# Compiler options
	# See generic.mk for defaults
	CFLAGS=-Wall -fmessage-length=0 -fstack-usage -Wno-unused-function 

# Linker Options
	# NOSTARTUPFILES
	# Set to 1 if you do not want to include the startfile from the toolchain
	# If you set that to 1 and do not include a startup file, you may get the error "ld.exe: invalid data statement"
	NOSTARTFILES=0
	
	# LIBS
	# Define to add libraries
	LIBS=-ltpoCryptoHash -ltpoCryptoPka -ltpoCryptoSym -ltpoCryptoDrbg -ltpoCryptoAlloc -ltpoCryptoCore -ltpoCryptoPrng
	
	# LIBSINC
	# Define to add search path for libraries
	
	# LDSCRIPT
	# Custom linker script
	#LDSCRIPT=ldscript.x

# Build general options
	# REBUILD_BY_DEFAULT
	# Set this to 0 if you want incremental builds
	REBUILD_BY_DEFAULT=1

#PATHs options
	# TARGET_SDK_ROOT
	# Define it to choose a particular version of the SDK
	# Note: 
	# 	This is ignored when using eclipse, eclipse builds always
	#   use the toolchain selected from eclipse project settings
	#   Project->Properties->C/C++ Build->Environment->TESIC_PATH
	#TARGET_SDK_ROOT=C:\_SDK\TESIC_04000R10-GCC6.1-SDK-1.1.0
	
	# TARGET_TOOLCHAIN_PATH
	# Define it to choose a particular version of the toolchain
	# By default the toolchain is selected based on TARGET_SDK_ROOT
	# Note: 
	# 	This is ignored when using eclipse, eclipse builds always
	#   use the toolchain selected from eclipse project settings
	#   Project->Properties->C/C++ Build->Environment->TESIC_TOOLCHAIN_PATH
	#TARGET_TOOLCHAIN_PATH=C:\_SDK\TESIC_04000R10-GCC6.1-SDK-1.1.0\toolchains\tam16exv2-mingw32
    

	
include $(CSP_ROOT)/generic/makefiles/generic.mk

