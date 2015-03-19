#!/usr/bin/env python 

extra = '''
default_target_dir = 'venv'
pip_install_packages = filter(len, open('requirements.txt').readlines())
import os
import subprocess
import sys
def adjust_options(options, args):
  if len(args)==0:
    args.append(default_target_dir)

def after_install(options, home_dir):
  from os.path import join
  pip = join(home_dir, 'bin/pip')
  if not os.path.exists(pip):
    # on windows
    pip = join(home_dir, 'Scripts/pip.exe')
  if not os.path.exists(pip):
    print "error", pip, "is missing"
  if sys.version_info < (2, 7):
    subprocess.call([pip, 'install', 'importlib'])
  for prog in pip_install_packages:
    subprocess.call([pip, 'install', prog])
'''

import os
import virtualenv


output = virtualenv.create_bootstrap_script(extra)
f = open('bootstrap.sh', 'w').write(output)



## Credit to https://github.com/jansel/opentuner/blob/master/gen-venv-bootstrap.py