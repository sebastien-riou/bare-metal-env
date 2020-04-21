# bare-metal-env

This is a cross platform bare metal development environment which aims at being usable from command line and from IDEs like Eclipse. An aditional goal is to observe the "DRY" principle ("Don't Repeat Yourself").

The stuff for users is within `csp_root` folder. 
Files outside of this folder are for developpers of the framework.

## How to develop a CSP ?

### Git setup
- define the "Generic SDK long name" for your CSP
- Create a repo with that name, all in UPPER case
- clone this repo
- within `csp_root`, clone your repo

### Initial integration
File up your folder according to the template in the `template_csp`

## Notes and links

### Git and submodules:

Git Pull with Submodule
For a repo with submodules, we can pull all submodules using

git submodule update --init --recursive
for the first time. All submodules will be pulled down locally.

To update submodules, we can use

git submodule update --recursive --remote
or simply

git pull --recurse-submodules

from: openmetric.org/til/programming/git-pull-with-submodule/

## SSH guide
https://www.cyberciti.biz/faq/how-to-set-up-ssh-keys-on-linux-unix/

## ASCII
https://www.rapidtables.com/convert/number/hex-to-ascii.html
