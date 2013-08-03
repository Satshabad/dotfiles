#!/usr/bin/env python

import time
import subprocess
import re

start_time = int(time.time())

cmd = ['amixer', 'get', 'Master']

proc = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE)

x = proc.communicate()

vol = int(re.findall(r'\[(\d?\d?\d)\%\]', x[0])[0])

cmd = ['amixer', 'set', 'Master', '0']

proc = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE)

time.sleep(25)

cmd = ['amixer', 'set', 'Master', str(vol)+'%', 'unmute']

proc = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE)

