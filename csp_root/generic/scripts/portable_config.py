#do not use shebang here. this is troublesome on some windows systems
#portable environment variable setting using python for conf file

#meant to be used like this:
#Linux:
#   $`python3 portable_config.py conf_file.py`
#Windows:
#   C:\>set myenv=python portable_config.py conf_file.py
#   C:\>%myenv%
#Makefile:
#

import os
import sys
import runpy
import platform
import sysconfig
from os import environ
#print("environ",environ)
#print("environ['SHELL']",environ['SHELL'])
#print("platform.system()",platform.system())
#print("sysconfig.get_platform()",sysconfig.get_platform())

#detecting Windows or Linux is not enough as in windows we may well run inside a bash terminal (cygwin, msys, git-bash...)
#if platform.system() == "Windows":
#if sysconfig.get_platform().lower().startswith("win"):

DOS_BATCH = 'TERM' not in environ

if DOS_BATCH:
    prolog = "set "
    epilog = ""
else:
    prolog = "export "
    epilog = ""

conf_path = sys.argv[1]
conf = runpy.run_path(conf_path)

if len(sys.argv) == 3:
    name=sys.argv[2]
    print("%s"%(conf[name]))
    sys.exit(0)

for name in conf:
    if name.startswith("__"):
        continue
    print("%s%s=%s%s"%(prolog,name,conf[name],epilog))
