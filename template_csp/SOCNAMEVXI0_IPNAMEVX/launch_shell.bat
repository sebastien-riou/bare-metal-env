@echo off
CALL scripts\launch_common.bat

REM (echo %SDK_GENERIC_SHORT_NAME%)>SDK_GENERIC_SHORT_NAME
REM (echo %SDK_SHORT_NAME%)>SDK_SHORT_NAME
REM (echo %SDK_LONG_NAME_PREFIX%)>SDK_LONG_NAME_PREFIX
REM (echo %SDK_ROOT%)>SDK_ROOT

start %SDK_ROOT%\mingw\msys\1.0\bin\bash.exe --init-file scripts/shinit.sh
