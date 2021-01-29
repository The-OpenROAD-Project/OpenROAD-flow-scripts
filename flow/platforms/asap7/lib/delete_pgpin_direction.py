import os, sys
import os
import os.path


f = open('./asap7_merged_all.lib', 'r')

lines = f.readlines()
f.close()
fo = open('./mod.lib', 'w')
flag_pg = 0
for line in lines:
  if len(line.split())<1:
    fo.write(line)
    continue
  if line.split()[0]=='pg_pin':
    flag_pg = 1
    fo.write(line)
    continue
  if flag_pg==1 and line.split()[0]=='}':
    flag_pg=0
    fo.write(line)
    continue
  if flag_pg==1 and line.split()[0]=='direction':
    continue
  fo.write(line)
fo.close()
  


