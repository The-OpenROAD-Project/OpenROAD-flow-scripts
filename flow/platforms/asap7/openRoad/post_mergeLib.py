#!/usr/bin/env python3
import os
import sys
import os.path

print("[INFO-FLOW] Post Merge Lib")
mergedFile = sys.argv[1]
print("[INFO-FLOW]  " , mergedFile)
f = open(mergedFile, 'r')

lines = f.readlines()
f.close()
fo = open(mergedFile, 'w')
flag_pg = 0
for line in lines:
  if len(line.split())<1:
    fo.write(line)
    continue
  if line.split()[0]=='pg_pin':
    flag_pg = 1
    fo.write(line)
#    fo.write(' direction : input;\n')
    continue
  if flag_pg==1 and line.split()[0]=='}':
    flag_pg=0
    fo.write(line)
    continue
  if flag_pg==1 and line.split()[0]=='direction':
    continue
  fo.write(line)
fo.close()
  


