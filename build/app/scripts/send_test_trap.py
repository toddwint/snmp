#!/usr/bin/env python3
#!python3
'''
 Input a CSV that has SNMP user information.
 Use this information to send a test trap.
'''
__version__ = '0.0.0'

import argparse
import csv
import os
import pathlib
import subprocess

appname = os.environ['APPNAME']
csv_filename = 'snmp_users.csv'
csv_path = pathlib.Path(f'/opt/{appname}/upload')

# Create command line arguments (optionally to get a different filename)
parser = argparse.ArgumentParser(
    description=__doc__,
    epilog='If you need more help, tough.',
    )
parser.add_argument(
    '-v', '--version',
    help='show the version number and exit',
    action='version',
    version=f'Version: {__version__}',
    )
parser.add_argument(
    'filename',
    nargs='?',
    type=pathlib.Path,
    default=csv_filename,
    help=f'name of CSV file (default={csv_filename})',
    )
args = parser.parse_args()
csv_filename = csv_path / args.filename

if not csv_filename.exists():
    msg = f'[ERROR] `{csv_filename.name}` was not found. Exiting.'
    print(msg)
    raise(Exception(f'{msg}'))

csvlist = list(csv.reader(csv_filename.read_text().rstrip().split('\n')))
engineid, user, authalg, authphr, privalg, privphr = 0, 1, 2, 3, 4, 5
snmpusers = csvlist[1:]


for n,snmpuser in enumerate(snmpusers,1):
    print(f'{n}. {snmpuser}')
sel = input(f'Please select a user [1-{n}] (1): ') or '1'
if not all((sel.isnumeric(), int(sel) <= n)):
    raise Exception('You did not enter a correct entry. Bye.')

snmpuser = snmpusers[int(sel)-1]

rval = subprocess.run(
    f'snmptrap -v 3 -n "" -a {snmpuser[authalg]} -A {snmpuser[authphr]} -x {snmpuser[privalg]} -X {snmpuser[privphr]} -l authPriv -u {snmpuser[user]} -e {snmpuser[engineid]} 127.0.0.1 0 linkUp.0',
    shell=True,
    universal_newlines=True,
    capture_output=True
    )
print(rval.args, rval.stdout, rval.stderr, sep='\n')

print('Done!')
