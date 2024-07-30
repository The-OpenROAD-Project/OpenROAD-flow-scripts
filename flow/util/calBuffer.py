import re

pattern = "(hold\d+)"
cset = set()
count = 0

with open("reports/gf12/bp_single/min_delay_report_osta.rpt", "r") as f:
    while True:
        line = f.readline()
        if not line:
            break

        m = re.search(pattern, line)
        if m:
            name = m.group(0)
            if name not in cset:
                cset.add(name)
                count += 1
            else:
                continue

print(count)
