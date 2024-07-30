import re

startpoint = "Startpoint"
pattern = "(hold\d+)"
res = {}
count = 0
maxcount = 0
linindex = 0
lincount = 0
with open("reports/gf12/bp_single/min_delay_report_osta.rpt", "r") as f:
    while True:
        line = f.readline()
        lincount += 1
        if not line:
            break

        m1 = re.search(startpoint, line)
        m2 = re.search(pattern, line)
        if m1:
            if count == 0:
                continue
            elif count in res.keys():
                res[count] += 1
            else:
                res[count] = 1
                if count > maxcount:
                    maxcount = count
                    linindex = lincount
            count = 0
        elif m2:
            count += 1

for key, val in res.items():
    print("%d: %d" % (key, val))

print(maxcount)
print(linindex)
