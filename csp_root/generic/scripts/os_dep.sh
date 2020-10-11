#this file is meant to be sourced

./os_is_linux
export OS_IS_LINUX=$?
echo "OS_IS_LINUX='$OS_IS_LINUX'"
if [ $OS_IS_LINUX -ne 0 ]
then
    export EXE_EXT=""
else
    export EXE_EXT=.exe
fi

if [ "" == "$PYTHON" ]; then

    if [ $OS_IS_LINUX -ne 0 ]
    then
        export PYTHON=python3
        export PIP=pip3
    else
        export PYTHON=python
        export PIP=python
    fi

    #echo "ERROR: \$python not defined"
    #read -n 1 -s -r -p "Press any key to exit"
    #echo ""
    #exit 1
fi

echo "Using '$PYTHON' as python"
