@echo off
CALL scripts\launch_common.bat

set CSP_ROOT=%CD%\..

python %CSP_ROOT%\generic\scripts\check_python_version.py

if %ERRORLEVEL% EQU 0 (
    REM echo "ok"
) else (
    echo "'load' and 'run' make targets may not work"
    pause
)

start %SDK_ROOT%\eclipse\eclipse.exe
REM start %SDK_ROOT%\mingw\msys\1.0\bin\bash.exe -c "source launch_eclipse.sh"
