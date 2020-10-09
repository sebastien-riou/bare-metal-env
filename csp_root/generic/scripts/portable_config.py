#portable environment variable setting using python for conf file

#meant to be used like this:
#Linux:
#   $`python3 portable_config.py conf_file.py`
#Windows:
#   C:\>set myenv=python portable_config.py conf_file.py
#   C:\>%myenv%

import sys
import runpy
import platform

if platform.system() == "Windows":
    prolog = "set "
    epilog = ""
else:
    prolog = "export "
    epilog = ""

conf_path = sys.argv[1]
conf = runpy.run_path(conf_path)
for name in conf:
    if name.startswith("__"):
        continue
    print("%s%s=%s%s"%(prolog,name,conf[name],epilog))
