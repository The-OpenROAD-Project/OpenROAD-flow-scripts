#!/usr/bin/env python3
import sys

mergedFile = sys.argv[1]
print("Post Merge Lib", mergedFile)
with open(mergedFile, "r") as f:
    lines = f.readlines()
    f.close()
    fo = open(mergedFile, "w")
    flag_pg = 0
    for line in lines:
        if len(line.split()) < 1:
            fo.write(line)
            continue
        if line.split()[0] == "pg_pin":
            flag_pg = 1
            fo.write(line)
            #    fo.write(' direction : input;\n')
            continue
        if flag_pg == 1 and line.split()[0] == "}":
            flag_pg = 0
            fo.write(line)
            continue
        if flag_pg == 1 and line.split()[0] == "direction":
            continue
        fo.write(line)
