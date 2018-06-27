#!/usr/bin/python
#*****************************************************************************
#  externals.py
#******************************************************************************

"""
####################
externals.py
####################
Code facilitating the execution of external system calls.
"""


import subprocess
import os
import sys

from errors import *

# ++++++++ Verifying/preparing external environment ++++++++
def whereis(program):
    """
    returns path of program if it exists in your ``$PATH`` variable or ``None`` otherwise
    """
    for path in os.environ.get('PATH', '').split(':'):
        if os.path.exists(os.path.join(path, program)) and not os.path.isdir(os.path.join(path, program)):
            return os.path.join(path, program)
    return None

def mkdirp(path):
    """
    Create new dir while creating any parent dirs in the path as needed.
    """

    if not os.path.isdir(path):
        try:
            os.makedirs(path)
        except OSError as errTxt:
            if "File exists" in errTxt:
                sys.stderr.write("FYI: %s" % (errTxt))
            else:
                raise
            
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

def runExternalApp(progName,argStr):
    """
    Convenience func to handle calling and monitoring output of external programs.
    
    :param progName: name of system program command
    :param argStr: string containing command line options for ``progName``
    
    :returns: subprocess.communicate object
    """
    
    # Ensure program is callable.
    progPath = whereis(progName)
    if not progPath:
        raise SystemCallError(None,'"%s" command not found in your PATH environmental variable.' % (progName))
    
    # Construct shell command
    cmdStr = "%s %s" % (progPath,argStr)
    
    # Set up process obj
    process = subprocess.Popen(cmdStr,
                               shell=True,
                               stdout=subprocess.PIPE,
                               stderr=subprocess.PIPE)
    # Get results
    result  = process.communicate()
    
    # Check returncode for success/failure
    if process.returncode != 0:
        raise SystemCallError(process.returncode,result[1],progName)
    
    # Return result
    return result

def remove_empty_from_dict(d):
    if type(d) is dict:
        return dict((k, remove_empty_from_dict(v)) for k, v in d.iteritems() if v and remove_empty_from_dict(v))
    elif type(d) is list:
        return [remove_empty_from_dict(v) for v in d if v and remove_empty_from_dict(v)]
    else:
        return d

