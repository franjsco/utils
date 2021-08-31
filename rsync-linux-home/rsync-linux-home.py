#!/bin/python3
##################################################
# rsync-linux-home.py                            #
# @franjsco                                      #
# https://github.com/franjsco/utils              #
##################################################
import subprocess
import getpass
import os

DRIVE_UUID="" # set here your UUID of destination partition

USER=getpass.getuser()
MNT_DIR="/run/media/{user}".format(user=USER)

SRC_DIR="/home/{}/".format(USER)
DEST_DIR="{mnt_dir}/{drive_uuid}/rsync-linux-home/".format(mnt_dir=MNT_DIR,drive_uuid=DRIVE_UUID)
LOG_FILENAME = 'rsync.log'

# rsync options
OPTIONS = [
    "-avruhz",
    "--delete",
    "--stats",
    "--log-file={LOG_FILENAME}".format(LOG_FILENAME=LOG_FILENAME)
] 

# directories includes (pattern rsync include/exclude)
INCLUDES = [
    "Progetti/***",
    "Scrivania/***",
    "Documenti/***",
    "Immagini/***",
    "Musica/***",
    "Video/***"
]

# directories excludes (pattern rsync include/exclude)
EXCLUDES = [
    "*"
]


def is_device_connected():
    return os.path.isdir("{MNT_DIR}/{UUID}/".format(MNT_DIR=MNT_DIR, UUID=DRIVE_UUID))


def generate_includes(inc):
    includes=[]
    for i in inc:
        includes.append("--include={}".format(i))
    
    return includes


def generate_excludes(ex):
    excludes=[]
    for e in ex:
        excludes.append("--exclude={}".format(e))
    
    return excludes


def generate_statement(options, includes, excludes, source, destination):
    includes_generated = generate_includes(includes)
    excludes_generated = generate_excludes(excludes)

    cmd=['rsync'] #,'--dry-run']

    for o in options:
        cmd.append(o)
    
    for i in includes_generated:
        cmd.append(i)

    for e in excludes_generated:
        cmd.append(e)
    
    cmd.append(source)
    cmd.append(destination)

    return cmd


def execute_backup(cmd):   
    summary_backup() 
    try:
        print("> Backup Started")
        process = subprocess.run(cmd, check=True, capture_output=True)
        
        print(process.stdout.decode('UTF-8'))
        
        print("> Backup Terminated")
    except subprocess.SubprocessError as sperror:
        print("> Backup Aborted")
        print('Error rsync')
        print("Exit code: {}".format(sperror.args[0]))
        exit(sperror.args[0])
    except Exception as exception:
        print("> Backup Aborted")
        print('Error')
        print(exception)
        exit(1)



def summary_backup():
    print("""rsync-linux-home
from: {source}
to: {destination}

log file: {log_file}

rsync options: {opt}""".format(source=SRC_DIR, destination=DEST_DIR, opt=OPTIONS, log_file=LOG_FILENAME))


if is_device_connected():
    cmd = generate_statement(OPTIONS, INCLUDES, EXCLUDES, SRC_DIR, DEST_DIR)
    execute_backup(cmd)
else:
    print("""error: device with UUID={UUID} 
is not mountend into {MNT_DIR}""".format(UUID=DRIVE_UUID,MNT_DIR=MNT_DIR))