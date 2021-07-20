#do not use shebang here. this is troublesome on some windows systems

import os
import sys
import stat
import shutil

src_toolchain="/home/sdk-support/releases/toolchains/csp"
serv="SERV100"

def get_user():
    global user_serv
    if(len(sys.argv) > 1):
        user_serv = sys.argv[1]
    else:
        #user_serv = 'sdk-support'
        user_serv = 'sdk-support'

def shell(cmd):
    stream = os.popen(cmd)
    output = stream.read()
    return output

def del_rw(action, name, exc):
    os.chmod(name, stat.S_IWRITE)
    os.remove(name)

def ignore(dir,files):
    ignored=list()
    ignore_file = os.path.join(dir,'.ignore')
    user_list=list()
    if os.path.exists(ignore_file):
        user_list=open(ignore_file,'r').read().split('\n')
    for f in files:
        if f in ['.git', '.gitignore', '.gitattribute', '.ignore']:
            ignored.append(f)
        elif f in user_list:
            ignored.append(f)
    return ignored

def get_toolchain(user, srv, src, dst):
    if os.path.exists(dst):
        shutil.rmtree(os.path.realpath(dst))

    os.mkdir(os.path.realpath(dst))
    cmd="scp -r "+user+"@"+srv+":"+src+"/tam16exv2-mingw32 "+os.path.realpath(dst)
    print(shell(cmd))
    # cmd="scp -r "+user+"@"+srv+":"+src+"/* "+os.path.realpath(dst)  => pb with tam16exv2-linux64
    # print(shell(cmd))

dst=os.environ['TMP']
if len(sys.argv)>2:
    dst=sys.argv[2]
dst=os.path.realpath(dst)
csp_root=os.path.join(dst,'csp_root')

dst_toolchain=os.path.join(dst,'bare-metal-env/csp_root/SQN34X0VXI0_TESIC_0400XRXX/dependencies/tam16exv2')

src_csp_root=os.path.realpath(os.environ['CSP_ROOT'])
print(dst,csp_root,src_csp_root)
os.chdir(src_csp_root)
repo = shell('git config --get remote.origin.url')
print(repo)
os.chdir(dst)

repo_root=os.path.join(dst,'bare-metal-env')

for output_dir in [csp_root, repo_root]:
    if os.path.exists(output_dir):
        shutil.rmtree(output_dir, onerror=del_rw)

print(shell('git clone '+repo))
repo_csp_root = os.path.join(dst,'bare-metal-env','csp_root')
os.chdir(repo_csp_root)
sdk_long_names=next(os.walk(src_csp_root))[1]
for sdk_long_name in sdk_long_names:
    if sdk_long_name in ['generic', 'workspace']:
        continue
    src_csp_target_root=os.path.join(src_csp_root,sdk_long_name)
    print(src_csp_target_root)
    os.chdir(src_csp_target_root)
    repo = shell('git config --get remote.origin.url')
    os.chdir(repo_csp_root)
    print(shell('git clone -b WIP-TAM16-OUTSIDE '+repo))
    # print(shell('git clone '+repo))
    os.chdir(os.path.join(repo_csp_root,sdk_long_name))

    get_user()
    get_toolchain(user_serv, serv, src_toolchain, dst_toolchain)

    print(shell('git submodule update --init --recursive'))
    print(shell('git submodule update --remote --merge'))

print('Copy to release folder "%s"'%csp_root)
shutil.copytree(src=repo_csp_root, dst=csp_root, symlinks=False, ignore=ignore)

sdk_long_names=next(os.walk(csp_root))[1]
for sdk_long_name in sdk_long_names:
    if sdk_long_name in ['generic', 'workspace']:
        continue
    csp_target_root=os.path.join(csp_root,sdk_long_name)
    print(csp_target_root)
    #os.cwd(sdk_long_name)
