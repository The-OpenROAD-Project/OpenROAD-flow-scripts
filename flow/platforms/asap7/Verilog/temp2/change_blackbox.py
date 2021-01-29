import os, sys
import os
import os.path



#f = open('./C28SOI_SC_12_CLK_LR.blackbox.v', 'r')
#f = open('./C28SOI_SC_12_CORE_LR.v', 'r')
#f = open('./C28SOI_SC_12_CLK_LR.v', 'r')

for filename in os.listdir(os.getcwd()):
  with open(os.path.join(os.getcwd(), filename), 'r') as f:
    lines = f.readlines()
    f.close()

    fo = open('./%s_new.v'%filename, 'w')
    for line in lines:
      if len(line.split())<1:
        continue
      head = line.split()[0]
      if head=='primitive':
        break
      if head=='module' or head=='input' or head=='output' or head=='endmodule':
        if head=='module':
          line = '(* blackbox *) ' + line
        print(head)
        fo.write(line)
      else:
        continue

    fo.close()

