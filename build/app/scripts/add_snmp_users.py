#!/usr/bin/env python3
#!python3
'''
 Input a CSV that has SNMP user information.
 Add this information to the SNMP configuration:
 `/etc/snmp/snmptrapd.conf`
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
snmpusers = csvlist[1:]
engineid, user, authalg, authphr, privalg, privphr = 0, 1, 2, 3, 4, 5
snmptrapdconf = pathlib.Path('/etc/snmp/snmptrapd.conf')
snmptrapdtmpl = pathlib.Path(f'/opt/{appname}/configs/snmptrapd.conf')
snmpcfg = snmptrapdtmpl.read_text()

for snmpuser in snmpusers:
    if snmpuser[user] and snmpuser[engineid]:
        snmpcfg += f'createUser -e {snmpuser[engineid]} {snmpuser[user]} \
{snmpuser[authalg]} {snmpuser[authphr]} {snmpuser[privalg]} \
{snmpuser[privphr]}' '\n'
        snmpcfg += f'authUser log,execute,net {snmpuser[user]} noauth' '\n'
    elif snmpuser[user]:
        snmpcfg += f'createUser {snmpuser[user]} {snmpuser[authalg]} \
{snmpuser[authphr]} {snmpuser[privalg]} {snmpuser[privphr]}' '\n'
        snmpcfg += f'authUser log,execute,net {snmpuser[user]} noauth' '\n'

snmptrapdconf.write_text(snmpcfg)

print('Done!')
