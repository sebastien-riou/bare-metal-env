#this file is meant to be sourced while the current directory is a child of csp_root
export PATH=.:/usr/local/bin:/mingw/bin:/bin:$PATH
function unixpath() {
    echo "$1" \
    | sed -r \
      -e 's/\\/\//g' \
      -e 's/^([^:]+):/\/\1/'
}
function resolve_dir() {
        (builtin cd `dirname "${1/#~/$HOME}"`'/'`basename "${1/#~/$HOME}"` 2>/dev/null; if [ $? -eq 0 ]; then pwd; fi)
}
export CSP_ROOT=`resolve_dir $(pwd)/..`/
export SDK_ROOT=`unixpath $SDK_ROOT`
export SDK_GENERIC_SHORT_NAME=`unixpath $SDK_GENERIC_SHORT_NAME`
export SDK_SHORT_NAME=`unixpath $SDK_SHORT_NAME`
export SDK_LONG_NAME_PREFIX=`unixpath $SDK_LONG_NAME_PREFIX`

if [ -d "$SDK_ROOT" ]; then
  echo ""
else
  echo "ERROR: ${SDK_ROOT} not found. Can not continue."
  read -n 1 -s -r -p "Press any key to exit"
  echo ""
  exit 1
fi

python $CSP_ROOT/generic/scripts/check_python_version.py

PYTHON_ERROR=$?

if [ $PYTHON_ERROR -ne 0 ]
then
  echo "'load' and 'run' make targets may not work"
  read -n 1 -s -r -p "Press any key to continue"
  echo ""
  #let user go on, we did warn her
  #exit 1
fi

echo "CSP_ROOT=$CSP_ROOT"
echo "SDK_LONG_NAME_PREFIX  =$SDK_LONG_NAME_PREFIX"
echo "SDK_GENERIC_SHORT_NAME=$SDK_GENERIC_SHORT_NAME"
echo ""
echo "SDK_SHORT_NAME        =$SDK_SHORT_NAME"
echo "SDK_ROOT=$SDK_ROOT"
cd projects
