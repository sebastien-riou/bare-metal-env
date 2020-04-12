if "%1" == "" goto :set_default1
set SDK_ROOT=%1
if "%2" == "" goto :set_default2
set SDK_SHORT_NAME=%2
goto :done
:set_default1
REM default to latest version if not set as environment variable
IF "%SDK_ROOT%"=="" set SDK_ROOT=C:\_SDK\IPNAMEVX_SDK_V1.0.0
:set_default2
REM default to latest version if not set as environment variable
IF "%SDK_SHORT_NAME%"=="" set SDK_SHORT_NAME=IPNAMEV0
:done
set SDK_GENERIC_SHORT_NAME=IPNAMEVX
set SDK_LONG_NAME_PREFIX=SOCNAMEVXI0_

IF EXIST %SDK_ROOT% (
    echo 
) ELSE (
    echo ""
    echo ERROR: SDK_ROOT defined as '%SDK_ROOT%'
    echo This path does not exist
    echo ""
    echo Fix that by setting SDK_ROOT environment variable or give it as first argument of this script
    echo ""
    pause
    exit
)
