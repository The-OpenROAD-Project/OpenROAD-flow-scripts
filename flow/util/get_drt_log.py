import os
import sys
import glob
import re
import numpy as np
import matplotlib.path as mplPath
import itertools
import matplotlib.pyplot as plt
from matplotlib.ticker import MaxNLocator
from matplotlib.ticker import ScalarFormatter
from matplotlib.ticker import NullFormatter
from matplotlib.ticker import LogLocator, AutoLocator
import pandas as pd
import imageio

#rpt_num = 
#string_rpt_num = '-%s.rpt'%rpt_num

benchmark_list = ['ispd18_test1',
                  'ispd18_test10',
                  'ispd18_test3', 
                  'ispd18_test4', 
                  'ispd18_test5', 
                  'ispd18_test6', 
                  'ispd18_test7', 
                  'ispd18_test8', 
                  'ispd18_test9', 
                  'ispd19_test1', 
                  'ispd19_test2', 
                  'ispd19_test3', 
                  'ispd19_test4', 
                  'ispd19_test5', 
                  'ispd19_test6', 
                  'ispd19_test7', 
                  'ispd19_test8', 
                  'ispd19_test9' ]
benchmark_list = ['ispd19_test10']
benchmark_list = ['sky130hd_ibex_base']

### worker from worker log
def make_worker(curr_iter, logfile):
  file_tr_log = open(logfile, 'r')
  worker_num = 0
  flag=0
  worker_prev_drvs = 0
  worker_curr_drvs = 0
  with open(logfile) as file_tr_log:
    for line in file_tr_log:
      if flag==0 and len(line.split())>1 and line.split()[0]=='Units:':
        unit = float(line.split()[1])
      if flag==0 and len(line.split())>6 and line.split()[1]=='area:':
        xlim_left = round(float(line.split()[3]) / unit,3)
        ylim_left = round(float(line.split()[4]) / unit,3)
        xlim_right = round(float(line.split()[7]) / unit,3)
        ylim_right = round(float(line.split()[8]) / unit,3)
      if flag==0 and len(line.split())>4 and line.split()[4] == 'optimization':
        if line.split()[3] == '%sst'%curr_iter or line.split()[3] == '%snd'%curr_iter or line.split()[3] == '%srd'%curr_iter or line.split()[3] == '%sth'%curr_iter:
          flag=1
          continue
      if flag==1 and len(line.split())>3 and line.split()[2] == 'worker':
        worker_num+=1
      if flag==1 and len(line.split())>5 and line.split()[5] == 'iteration.':
        break
  print('Curr_iter: %s #wokers (#tiles): %s'%(curr_iter, worker_num))
  worker_list = np.empty([worker_num,7])
  #print(worker_list, worker_num)
  worker_num_temp = 0
  flag=0
  with open(logfile) as file_tr_log:
    for line in file_tr_log:
      if flag==0 and len(line.split())>4 and line.split()[4] == 'optimization':
        if line.split()[3] == '%sst'%curr_iter or line.split()[3] == '%snd'%curr_iter or line.split()[3] == '%srd'%curr_iter or line.split()[3] == '%sth'%curr_iter:
          flag=1
          continue
      if flag==1 and len(line.split())>4 and line.split()[2] == 'Number':
        drvs_num = line.split()[6][:-1]
      if flag==1 and len(line.split())>3 and line.split()[2] == 'worker':
        worker_x_ll = float(line.split()[3][1:])
        worker_y_ll = float(line.split()[4][:-1])
        worker_x_ur = float(line.split()[5][1:])
        worker_y_ur = float(line.split()[6][:-1])
        worker_time = float(line.split()[8])
        worker_prev_drvs = int(line.split()[10])
        worker_curr_drvs = int(line.split()[12])
        #worker_name = '%s%s%s%s'%(worker_x_ll,worker_y_ll,worker_x_ur,worker_y_ur)
        #worker_dict = {'x_ll': worker_x_ll, 'y_ll': worker_y_ll, 'x_ur': worker_x_ur, 'worker_y_ur': worker_y_ur, 'time': worker_time}
        worker_list_temp = np.array([worker_x_ll, worker_y_ll, worker_x_ur, worker_y_ur, worker_time, worker_prev_drvs, worker_curr_drvs])
        #print(worker_num_temp)
        #print(len(worker_list))
        #worker_list[worker_name]= worker_list_temp
        worker_list[worker_num_temp]= worker_list_temp
        worker_num_temp+=1
      if flag==1 and len(line.split())>5 and line.split()[5] == 'iteration.':
        break
  #print('Curr_iter: %s #wokers (#tiles): %s'%(curr_iter, worker_num_temp))
  #print('Curr_iter: %s #wokers (#tiles): %s'%(curr_iter, worker_num))
  
  #worker_list = sorted(worker_list, key=lambda x: (x[0], x[1]))
  #print(worker_list)
  
  #worker_dict = {}
  #for i, worker in enumerate(worker_list):
  #  worker_dict_temp = {'x_ll': worker[0], 'y_ll': worker[1], 'x_ur': worker[2], 'y_ur': worker[3], 'time': worker[4], 'drc_num': 0}
  #  worker_dict['worker_%s'%i]=worker_dict_temp
  #return worker_dict, worker_num
  return worker_list, worker_num, drvs_num, xlim_left, ylim_left, xlim_right, ylim_right
  
def find_point(x1, y1, x2, y2, x, y):
  if x<x1:
   return False
  if x>=x2:
    return False
  if y<y1:
    return False
  if y>=y2:
    return False
  else:
    return True

# Build GIF
def build_gif(basename):
  with imageio.get_writer('drt_figs/%s/%s.gif'%(benchmark,basename), mode='I', fps=4) as writer:
    filenames = sorted(glob.glob('./drt_figs/%s/%s_iter_*'%(benchmark,basename)))
    image = imageio.imread(filenames[0])
    writer.append_data(image)
    writer.append_data(image)
    writer.append_data(image)
    writer.append_data(image)
    writer.append_data(image)
    writer.append_data(image)
    writer.append_data(image)
    writer.append_data(image)
    for filename in filenames:
      image = imageio.imread(filename)
      writer.append_data(image)
    image = imageio.imread(filenames[-1])
    writer.append_data(image)
    writer.append_data(image)
    writer.append_data(image)
    writer.append_data(image)
    writer.append_data(image)
    writer.append_data(image)
    writer.append_data(image)
    writer.append_data(image)

for benchmark in benchmark_list:  
  platform = benchmark.split('_')[0]
  design = benchmark.split('_')[1]
  variant = benchmark.split('_')[2]
  logfile = './logs/%s/%s/%s/5_2_TritonRoute.log'%(platform, design, variant)
  outlog = 'drt_figs/%s/%s.log'%(benchmark,benchmark)
  if not os.path.exists('drt_figs'):
    os.makedirs('drt_figs')
  if not os.path.exists('drt_figs/%s'%benchmark):
    os.makedirs('drt_figs/%s'%benchmark)
  fo = open(outlog, 'w')
  filenames = sorted(glob.glob('./drt_figs/%s/drc_dist*'%(benchmark)))
  for filename in filenames:
    if os.path.exists(filename):
      os.remove(filename)
  filenames = sorted(glob.glob('./drt_figs/%s/runtime_dist*'%(benchmark)))
  for filename in filenames:
    if os.path.exists(filename):
      os.remove(filename)

  #iter_num_list = []
  data_iter = []
  data_drvs_num = []
  data_worker_num = []
  data_zerotiles_num = []
  data_runtime = []
  for rpt_path in glob.glob('./reports/%s/%s/%s/5_route_drc.rpt-*'%(platform,design,variant)):
    rpt_name = os.path.basename(rpt_path)
    iter_num = re.search('-(.*).rpt', rpt_name).group(1)
    #iter_num_list.append(iter_num)
  
  #for iter_num in iter_num_list:
    data_x_grid = []
    data_y_grid = []
    data_runtime_temp = []
    worker_list, worker_num, drvs_num, xlim_left, ylim_left, xlim_right, ylim_right = make_worker(iter_num, logfile)
    #print(worker_list, worker_num)
    #print('worker_num: %s'%worker_num)
    fo.write('Curr_iter: %s #wokers (#tiles): %s \n'%(iter_num, worker_num))
    worker_list = worker_list[worker_list[:,1].argsort()]
    worker_list = worker_list[worker_list[:,0].argsort(kind='mergesort')]
    #print(worker_list)
    zerotiles_num = 0
    count = 0
    iter_obj = itertools.cycle(worker_list)
    while count < len(worker_list):
      is_new_zerotile = 0
      worker=next(iter_obj)
      count+=1
      if int(worker[6]) == 0 and int(worker[6])!=int(worker[5]):
        is_new_zerotile = 1
        zerotiles_num += 1
      if int(worker[5]) != 0:
        data_runtime_temp.append(float(worker[4]))
      #print("worker x_ll: %f y_ll: %f x_ur: %f y_ur: %f time: %f prev_drv: %i curr_drv: %i is_new_zerotile: %i"%(worker[0], worker[1], worker[2], worker[3], worker[4], int(worker[5]), int(worker[6]), is_new_zerotile))
      print("worker x_ll: %f y_ll: %f x_ur: %f y_ur: %f time: %f prev_drv: %i curr_drv: %i"%(worker[0], worker[1], worker[2], worker[3], worker[4], int(worker[5]), int(worker[6])))
      fo.write("worker x_ll: %f y_ll: %f x_ur: %f y_ur: %f time: %f prev_drv: %i curr_drv: %i \n"%(worker[0], worker[1], worker[2], worker[3], worker[4], int(worker[5]), int(worker[6])))
      data_x_grid.append(float(worker[0]))
      data_y_grid.append(float(worker[1]))
      #data_runtime_temp.append(float(worker[4]))
    data_runtime.append(data_runtime_temp)
    print('iter: %i #DRVs: %i, worker_num: %i #new_zerotiles: %i'%(int(iter_num), int(drvs_num), int(worker_num), int(zerotiles_num)))
    fo.write('iter: %i #DRVs: %i, worker_num: %i #new_zerotiles: %i \n'%(int(iter_num), int(drvs_num), int(worker_num), int(zerotiles_num)))
    data_iter.append(int(iter_num))
    data_drvs_num.append(int(drvs_num))
    data_worker_num.append(int(worker_num))
    data_zerotiles_num.append(int(zerotiles_num))
    
  
    ### Graph Drawing ###
    
    parameters = {'axes.labelsize': 15,
            'axes.titlesize': 20,
            'legend.fontsize': 10,
            'xtick.labelsize': 10,
            'ytick.labelsize': 10}
    plt.rcParams.update(parameters)
    #print(data_x_grid)
    #print(data_y_grid)
    #print(len(data_x_grid))
    #print(len(data_y_grid))
  
    ## DRC distributions per iteration. ##
    
    #if int(iter_num)<4:
    #  continue
    fig = plt.figure(figsize=(8, 6))
    ax = fig.gca()
    plt.title("DRC Locations (iter %s)\n%s"%(str(iter_num), benchmark))
    plt.xlabel("Die X")
    plt.ylabel("Die Y")
    ax.set_xlim(xlim_left, xlim_right)
    ax.set_ylim(ylim_left, ylim_right)
    ax.text(1, 1, '#DRVs = %i'%int(drvs_num), horizontalalignment='right', fontsize=10,
            verticalalignment='bottom',
            transform=ax.transAxes)
    data_drc_x = []
    data_drc_y = []
    with open(rpt_path) as file_dr_rpt:
      drc_num = 0
      for line in file_dr_rpt:
        if len(line.split())>2 and line.split()[0] == 'violation':
          drc_num += 1
          #if drc_num % 1000 == 0:
          #  print(drc_num)
        if len(line.split())>2 and line.split()[0] == 'bbox':
          x_ll = float(line.split()[3][:-1])
          y_ll = float(line.split()[4])
          x_ur = float(line.split()[8][:-1])
          y_ur = float(line.split()[9])
          #print(x_ll, y_ll, x_ur, y_ur)
          x = round((x_ll + x_ur) / 2,3)
          y = round((y_ll + y_ur) / 2,3)
          data_drc_x.append(x)
          data_drc_y.append(y)
    plt.scatter(data_drc_x, data_drc_y, marker='x')
    plt.grid()
    #plt.show()
    plt.savefig('drt_figs/%s/drc_dist_iter_%02d.png'%(benchmark, int(iter_num)))
    #if int(iter_num)>20:
    #  break
    plt.close()

    
  fo.close()
    
  ## #new_zerotiles vs. iteration ##
  fig = plt.figure(figsize=(8, 6))
  ax = plt.subplot(2,1,1)
  X_axis = np.arange(len(data_iter))
  plt.title("#New clean tiles vs. iteration\n%s"%benchmark)
  ax.bar(X_axis - 0.2, data_worker_num, 0.4, label = "#Total_tiles")
  ax.bar(X_axis + 0.2, data_zerotiles_num, 0.4,label = "#New_clean_tiles")
  plt.ylabel("#Tiles")
  plt.xticks(X_axis, data_iter)
  ax.legend()
  #ax.text(1, 1, 'total #tiles = %i'%int(), horizontalalignment='right',
  #  verticalalignment='bottom',
  #  transform=ax.transAxes)
  
  data_norm_zerotiles_num = [i / j for i, j in zip(data_zerotiles_num, data_worker_num)]
  ax2 = plt.subplot(2,1,2)
  ax2.set_ylim(0, 1.0)
  ax2.bar(X_axis, data_norm_zerotiles_num, 0.4, label = "Normalized #New_clean_tiles ")
  plt.xlabel("Iteration Number")
  plt.ylabel("(Normalized)")
  plt.xticks(X_axis, data_iter)
  ax2.legend()
  plt.savefig('drt_figs/%s/newzero_vs_iter.png'%(benchmark))
  plt.close()
    
    
  ## #DRVs vs. iteration. ##
  fig = plt.figure(figsize=(8, 6))
  ax = fig.gca()
  X_axis = np.arange(len(data_iter))
  plt.title("#DRVs vs. iteration\n%s"%benchmark)
  #ax.plot(data_iter, data_drvs_num, linestyle='-', marker='o', label = "#DRVs")
  ax.plot(X_axis, data_drvs_num, linestyle='-', marker='o', label = "#DRVs")
  ax.yaxis.set_major_locator(MaxNLocator(integer=True))
  ax.set_yscale('symlog')
  ax.set_ylim(0)
  locmin = LogLocator(base=10.0, subs=np.arange(2, 10) * .1,
                                        numticks=100)
  ax.yaxis.set_minor_locator(locmin)
  ax.yaxis.set_minor_formatter(NullFormatter())
  plt.xlabel("Iteration Number")
  plt.ylabel("#DRVs")
  #ax.ticklabel_format(style='plain', axis='y')
  plt.xticks(X_axis, data_iter)
  #plt.xticks(data_iter)
  plt.grid(True,which="major", axis="y", linestyle='--')
  #ax.legend()
  #ax.text(1, 1, 'y-axis is symmetic logscale to avoid infinity around zero.'%int(), horizontalalignment='right',
  #  verticalalignment='bottom',
  #  transform=ax.transAxes)
  plt.savefig('drt_figs/%s/drvs_vs_iter.png'%(benchmark))
  plt.close()
  
  ## #tiles vs. iteration. ##
  fig = plt.figure(figsize=(8, 6))
  ax = fig.gca()
  X_axis = np.arange(len(data_iter))
  plt.title("#Tiles vs. iteration\n%s"%benchmark)
  ax.bar(X_axis, data_worker_num, 0.4, label = "#Tiles")
  plt.xlabel("Iteration Number")
  plt.ylabel("#Tiles")
  ax.yaxis.set_major_locator(MaxNLocator(integer=True))
  ax.ticklabel_format(style='plain')
  plt.xticks(X_axis, data_iter)
  #ax.legend()
  #ax.text(1, 1, 'total #tiles = %i'%int(), horizontalalignment='right',
  #  verticalalignment='bottom',
  #  transform=ax.transAxes)
  plt.savefig('drt_figs/%s/tiles_vs_iter.png'%(benchmark))
  plt.close()

    
  ## Runtime distribution histogram (y-axis: #workers) ##
  max_runtime = 0
  max_worker_num = 0
  n_bins = 20
  max_ylim = 0
  for runtime_list in data_runtime:
    for runtime in runtime_list:
      max_runtime = max(max_runtime, float(runtime))
    max_worker_num = max(max_worker_num, len(runtime_list))
  for i, iter_num in enumerate(data_iter):
    bin_lims = np.logspace(np.log10(0.01), np.log10(max_runtime),n_bins+1)
    bin_centers = 0.5*(bin_lims[:-1]+bin_lims[1:])
    bin_widths = bin_lims[1:]-bin_lims[:-1]
    xhist, _ = np.histogram(np.array(data_runtime[i]), bins=bin_lims)
    if len(xhist)!=0:
      xhistb = xhist/len(data_runtime[i])
    else:
      xhistb = np.zeros(n_bins)
    max_ylim = max(max_ylim, np.max(xhistb))
  for i, iter_num in enumerate(data_iter):
    fig = plt.figure(figsize=(8, 6))
    ax = fig.gca()
    plt.title("Runtime Distributions (iter %s)\n%s"%(str(iter_num), benchmark))
    plt.xlabel("Runtime (s)")
    plt.ylabel("(Normalized)")
    #ax.set_xlim(0, max_runtime)
    ax.set_xscale('log')
    #locmin = LogLocator(base=10.0, subs=np.arange(2, 10) * .1,
    #                                      numticks=100)
    #ax.xaxis.set_minor_locator(locmin)
    #ax.xaxis.set_minor_formatter(NullFormatter())
    #ax.set_ylim(0, max_worker_num)
    #ax.set_ylim(0, 1)
    N_points = len(data_runtime[i])
    #n_bins = 10**(np.arange(0,4))

    #bin_lims = np.linspace(0,max_runtime,n_bins+1)
    bin_lims = np.logspace(np.log10(0.01), np.log10(max_runtime),n_bins+1)
    bin_centers = 0.5*(bin_lims[:-1]+bin_lims[1:])
    bin_widths = bin_lims[1:]-bin_lims[:-1]

    xhist, _ = np.histogram(np.array(data_runtime[i]), bins=bin_lims)
    if len(xhist)!=0:
      #xhistb = xhist/np.max(xhist)
      xhistb = xhist/len(data_runtime[i])
    else:
      xhistb = np.zeros(n_bins)
    if len(data_runtime[i])!=0:
      distb=np.array(data_runtime[i])
      tt = len(data_runtime[i])
    else:
      distb=np.zeros(n_bins)
      tt = 1
    #ax.hist(distb, bins=n_bins, range=(0,max_runtime), density=True)
    #ax.hist(distb, bins=bin_lims)
    #ax.hist(data_runtime[i], bins=bin_lims, edgecolor='black', linewidth=1.2)
    #ax.hist(distb/tt, bins=bin_lims, range=(0,max_runtime), edgecolor='black', linewidth=1.2)
    ax.set_ylim(0, max_ylim)
    ax.bar(bin_centers, xhistb, width = bin_widths, align = 'center', edgecolor='black', linewidth=1.2, label='Normalized #Working_workers')
    ax.legend()
    ax.text(1, 1, '#Working_workers = %i'%int(len(data_runtime[i])), horizontalalignment='right', fontsize=10,
            verticalalignment='bottom',
            transform=ax.transAxes)
    plt.savefig('drt_figs/%s/runtime_dist_iter_%02d.png'%(benchmark, int(iter_num)))
    plt.close()

  
      
  build_gif('drc_dist')
  build_gif('runtime_dist')
  
  #plt.show() 

#  with open(rpt_path) as file_dr_rpt:
#    drc_num = 0
#    for line in file_dr_rpt:
#      if len(line.split())>2 and line.split()[0] == 'violation':
#        drc_num += 1
#        if drc_num % 1000 == 0:
#          print(drc_num)
#      if len(line.split())>2 and line.split()[0] == 'bbox':
#        x_ll = float(line.split()[3][:-1])
#        y_ll = float(line.split()[4])
#        x_ur = float(line.split()[8][:-1])
#        y_ur = float(line.split()[9])
#        #print(x_ll, y_ll, x_ur, y_ur)
#        x = round((x_ll + x_ur) / 2,3)
#        y = round((y_ll + y_ur) / 2,3)
#        #print(x, y)
#        count=0
#        iter_obj = itertools.cycle(worker_list)
#        while count < len(worker_list):
#          worker=next(iter_obj)
#          count+=1
#          if find_point(worker[0], worker[1], worker[2], worker[3], x, y)==True:
#            #print('true')
#            worker[5]+=1
#            #print(worker[1], worker[5])
#            break
#        #for worker in worker_list:
#          #break
#          #continue
#          #print(value['x_ll'], value['y_ll'], value['x_ur'], value['y_ur'], x, y)
#          #print(worker[0], worker[1], worker[2], worker[3], x, y)
#          #if find_point(worker[0], worker[1], worker[2], worker[3], x, y)==True:
#          #  #print('true')
#          #  worker[5]+=1
#          #  #print(worker[1], worker[5])
#          #  break
#          #if find_point(value['x_ll'], value['y_ll'], value['x_ur'], value['y_ur'], x_ll, y_ll)==True:
#          #if find_point(1,1,2,2, x_ll, y_ll)==True:
#            #worker_dict[key]['drc_num'] += 1
#            #print(key,value)
#            #print(key, value['drc_num'])
#            #break
#        
#  #print('rpt_name: %s iter_num: %s #drc: %s'%(rpt_name, iter_num,drc_num))
#  print('iter_num: %s #drc: %s'%(iter_num,drc_num))
#
#  drc_num_in_list = 0
#  for i, worker in enumerate(worker_list):
#    #print(key,value['drc_num'], value['time'], value['x_ll'], value['y_ll'], value['x_ur'], value['y_ur'])
#    print(i,worker[0], worker[1], worker[2], worker[3], worker[4], worker[5])
#    drc_num_in_list += worker[5]
#  print(drc_num, drc_num_in_list)
  



### gcell from GCELL grid
#file_tr_log = open('./5_2_TritonRoute.log', 'r')
#lines = file_tr_log.readlines()
#file_tr_log.close()
#for line in lines:
#  if len(line.split())>2 and line.split()[2] == 'GCELLGRID':
#    if line.split()[3] == 'X':
#      x_orig = int(line.split()[4])
#      x_num = int(line.split()[6])
#      x_step = int(line.split()[8])
#    if line.split()[3] == 'Y':
#      y_orig = int(line.split()[4])
#      y_num = int(line.split()[6])
#      y_step = int(line.split()[8])
#      break

# TODO: x and y is opposite in OR report. It will be fixed in the later OR update
#for gcell_y_ll in range(x_orig, x_num*x_step, x_step):
#  for gcell_x_ll in range(y_orig, y_num*y_step, y_step):
#    print(gcell_x_ll, gcell_y_ll)
  
