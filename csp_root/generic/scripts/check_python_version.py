#Return 0 if running on Python 3.x 64 bits, an error code otherwise
import sys
tested_version_major=3
tested_version_minor=7
tested_version_user="Python %d.%d 64 bits"%(tested_version_major, tested_version_minor)
current_version_user="Python %d.%d"%(sys.version_info.major,sys.version_info.minor)
instruction="\nPlease install %s or fix PATH environment variable\n"%tested_version_user
try:
    assert(sys.version_info.major == tested_version_major)
    assert(sys.version_info.minor >= tested_version_minor)
    if sys.version_info.minor > tested_version_minor:
        print("WARNING: you are using version '%s', tested version is '%s'"%(current_version_user,tested_version_user))
except:
    print("ERROR: Python version is %s"%(current_version_user))
    print(instruction)
    exit(1)

try:
    assert(sys.maxsize > 2**32)
except:
    print("ERROR: You have a 32 bit version of Python")
    print(instruction)
    exit(2)

exit(0)
