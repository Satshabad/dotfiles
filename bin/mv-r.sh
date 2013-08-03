#!/bin/bash

s=$1
d=$2

cwd=$(pwd)
if [[ ${d:0:1} != '/'  ]]; then
  d=${cwd}/${d}
fi
cd ${s}
find ./ -type d -exec mkdir ${d}/'{}' \; -exec touch -r '{}' ${d}/'{}' \;
find ./ ! -type d -exec mv -u '{}' ${d}/'{}' \;
cd ${cwd}
