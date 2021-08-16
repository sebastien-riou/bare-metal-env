#do not use shebang here. this is troublesome on some windows systems

import os
import sys
import stat
import shutil
import gzip
import argparse
import logging
import traceback
import py7zr
from datetime import date

today = date.today()
url_bare_metal_env="git@github.com:sebastien-riou/bare-metal-env.git"
branch_bare_metal_env="master"

url_sqn_module="git@github.com:Tiempogithub/SQN34X0VXI0_TESIC_0400XRXX.git"
src_toolchain='"S:\\5.Projet\\03-Application\\CSP\\Toolchains"'


def shell(cmd):
    stream = os.popen(cmd)
    output = stream.read()
    return output

def del_rw(action, name, exc):
    os.chmod(name, stat.S_IWRITE)
    os.remove(name)

def clone(url, *, module=None):
    if(module is not None):
        print(shell('git clone '+url+' '+module))
    else:
        print(shell('git clone '+url))

def clone_branch(url, *, branch='SQN34', module=None):
    if(module is not None):
        print(shell('git clone -b '+branch+' '+url+' '+module))
    else:
        print(shell('git clone -b '+branch+' '+url))

def get_submodule():
    print(shell('git submodule update --init --recursive'))
    print(shell('git submodule update --remote --merge'))

def checkout(*,branch, tag):
    print(shell('git fetch --all --tags'))
    if(tag is not None):
        print(shell('git checkout '+tag))
        print(shell('git reset --hard HEAD'))
    else:
        print(shell('git checkout '+branch))
        print(shell('git reset --hard HEAD'))
        print(shell('git pull'))

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

def remove_release(csp_root, bare_env_root):
    for output_dir in [csp_root, bare_env_root]:
        if os.path.exists(output_dir):
            shutil.rmtree(output_dir, onerror=del_rw)

def copy_release(dst, csp_root):
    dst=os.path.join(dst, 'csp_root')
    print('Copy to release from {} to {}'.format(csp_root, dst))
    shutil.copytree(src=csp_root, dst=dst, symlinks=False, ignore=ignore)

def zip_release(csp, sevenZip):
    with py7zr.SevenZipFile(sevenZip, 'w') as archive:
        archive.writeall(csp)

def get_toolchain(src, dst):
    if os.path.exists(dst):
        shutil.rmtree(os.path.realpath(dst))

    os.mkdir(os.path.realpath(dst))

    path='"'+os.path.realpath(dst)+'"'
    print("Copy from "+src+" ...")
    cmd="xcopy "+src+" "+os.path.realpath(dst)+" /e"
    print(shell(cmd))

def main(args=None):
    scriptname = os.path.basename(__file__)
    parser = argparse.ArgumentParser(scriptname)
    levels = ('DEBUG', 'INFO', 'WARNING', 'ERROR', 'CRITICAL')
    parser.add_argument('--log-level', default='INFO', choices=levels)
    parser.add_argument('--branch', default='SQN34', help='Branch of the chosen module SQN', type=str)
    parser.add_argument('--tag', default=None,  help='Tag of CSP Package', type=str)
    parser.add_argument('--module', default='SQN34X0VXI0_TESIC_0400XRXX', help='Name of the chosen moduel SQN', type=str)
    parser.add_argument('--dst', default=os.environ['TMP'], help='Path where to find the release', type=str)
    parser.add_argument('--zipname', default=None, help='Zip file name', type=str)

    options = parser.parse_args()

    logging.basicConfig(level=options.log_level,datefmt='%Y%m%d-%H:%M:%S',format='%(asctime)s.%(msecs)03d %(levelname)9s %(message)s')

    branch=options.branch
    tag=options.tag
    module=options.module
    dst=options.dst
    if(options.zipname is None):
        zipname = today.strftime("%Y%m%d")+"_csp_root.7z"
    else:
        zipname= options.zipname

    try:
        # Set folders
        dst=os.path.realpath(dst)
        csp_root=os.path.join(dst,'csp_root')
        bare_env_root=os.path.join(dst,'bare-metal-env')
        csp_root_submodule=os.path.join(bare_env_root,'csp_root')

        # Remove old existing release
        remove_release(csp_root, bare_env_root)
        logging.info("Removing old releases : done")

        # Get bare-env-metal
        os.chdir(dst)
        #clone(url_bare_metal_env)
        clone_branch(url_bare_metal_env, branch=branch_bare_metal_env, module=None)
        os.chdir('bare-metal-env')
        checkout(branch=branch_bare_metal_env,tag=None)
        logging.info("Get bare-env-metal : done")

        # Get SQN module
        os.chdir(bare_env_root)
        os.chdir('csp_root')
        # clone(url_sqn_module, module=module)
        # os.chdir(module)
        # checkout(branch=branch, tag=tag)
        clone_branch(url_sqn_module, branch=branch, module=module)
        logging.info("Get SQN module : done")

        # Update all submodules
        print("CURRENT FOLDER :::","\t",os.getcwd())
        os.chdir(module)
        get_submodule()
        logging.info("Update all submodules : done")

        # Get Toolchains
        dst_toolchain=os.path.join(dst,'bare-metal-env/csp_root/'+module+'/dependencies/tam16exv2')
        get_toolchain(src_toolchain, dst_toolchain)
        logging.info("Get Toolchains : done")

        # Copy release in dst
        copy_release(dst, csp_root_submodule)
        logging.info("Copy release in {} : done".format(dst))

        # Compress release
        os.chdir(dst)
        logging.info("Make release {} in {} : in process".format(csp_root, dst))
        zip_release('./csp_root', zipname)
        logging.info("Make release : done")

    except Exception as e:
        logging.critical(e)
        logging.critical(traceback.format_exc())
        return -1
    except:
        logging.critical("exception caught, exit")
        return -1

    logging.info("All done.")
    return 0

if __name__ == '__main__':
    ret=main()
    sys.exit(ret)
