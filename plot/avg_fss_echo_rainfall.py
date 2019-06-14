#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Feb 20 14:35:07 2019

@author: miayao
"""

import matplotlib.pyplot as plt
import numpy as np
import netCDF4 as nc
import os

Case  = "11 Typhoon cases"
fTime = "20100919060000"
period= "T3"

files=np.zeros(4)
path1='/home/miayao/maple_ncu/FSS/echofile/'+period
path2='/home/miayao/maple_adjust_vector/FSS/echofile/'+period
path3='/home/miayao/com_weak_WRF/FSS/echofile/'+period
path4='/home/miayao/WRF_result/FSS/echofile/'+period

files1=os.listdir(path1)
files2=os.listdir(path2)
files3=os.listdir(path3)
files4=os.listdir(path4)



fss_maple48=[]
fss_ref_maple48=[]
fss_maple144=[]
fss_ref_maple144=[]
fss_com=[]
fss_ref_com=[]
fss_wrf=[]
fss_ref_wrf=[]


a=0
b=0
c=0
d=0
for file in files1:
    if not os.path.isdir(file):
        f=nc.Dataset(path1+'/'+file)
        nthr =f.variables['NTHRS_ECHO'][:]
        thr  =f.variables['THRES_ECHO'][:]
        nleng=f.variables['NLENG_ECHO'][:]
        leng =f.variables['LENGTH_ECHO'][:]
        fss_maple48.append(np.transpose(f.variables['FSS_ECHO'][:]))
        fss_ref_maple48.append((f.variables['FSS_REF_ECHO'][:]))
        a +=1
for file in files2:
    if not os.path.isdir(file):
        f=nc.Dataset(path2+'/'+file)
        fss_maple144.append(np.transpose(f.variables['FSS_ECHO'][:]))
        fss_ref_maple144.append((f.variables['FSS_REF_ECHO'][:]))
        b +=1
for file in files3:
    if not os.path.isdir(file):
        f=nc.Dataset(path3+'/'+file)
        fss_com.append(np.transpose(f.variables['FSS_ECHO'][:]))
        fss_ref_com.append((f.variables['FSS_REF_ECHO'][:]))
        c +=1
for file in files4:
    if not os.path.isdir(file):
        f=nc.Dataset(path4+'/'+file)
        fss_wrf.append(np.transpose(f.variables['FSS_ECHO'][:]))
        fss_ref_wrf.append((f.variables['FSS_REF_ECHO'][:]))
        d +=1
print(a,b,c,d)     
fss_maple48=np.array(fss_maple48[:])
fss_ref_maple48=np.array(fss_ref_maple48[:])
fss_maple144=np.array(fss_maple144[:])
fss_ref_maple144=np.array(fss_ref_maple144[:])
fss_com=np.array(fss_com[:])
fss_ref_com=np.array(fss_ref_com[:])
fss_wrf=np.array(fss_wrf[:])
fss_ref_wrf=np.array(fss_ref_wrf[:])

ntime=25


avg_fss_maple48=np.mean(fss_maple48,axis=0)
avg_fss_ref_maple48=np.mean(fss_ref_maple48,axis=0)
avg_fss_maple144=np.mean(fss_maple144,axis=0)
avg_fss_ref_maple144=np.mean(fss_ref_maple144,axis=0)
avg_fss_com=np.mean(fss_com,axis=0)
avg_fss_ref_com=np.mean(fss_ref_com,axis=0)
avg_fss_wrf=np.mean(fss_wrf,axis=0)
avg_fss_ref_wrf=np.mean(fss_ref_wrf,axis=0)


x=np.mgrid[slice(0,25,1)]
#print(x)

fig, ax = plt.subplots(3, 3)

for i in range(len(avg_fss_maple48[0,:,0])-3):
    ax[0,0].plot(x,avg_fss_maple48[1,i,:],label='L = ' +(str( '%2.0f' %round(leng[i]*110*0.0125)))+' km',linewidth=2)
    ax[1,0].plot(x,avg_fss_maple48[5,i,:],label='L = ' +(str( '%2.0f' %round(leng[i]*110*0.0125)))+' km',linewidth=2)
    ax[2,0].plot(x,avg_fss_maple48[7,i,:],label='L = ' +(str( '%2.0f' %round(leng[i]*110*0.0125)))+' km',linewidth=2)

for i in range(len(avg_fss_maple144[0,:,0])-3):
    ax[0,1].plot(x,avg_fss_maple144[1,i,:],label='L = ' +(str( '%2.0f' %round(leng[i]*110*0.0125)))+' km',linewidth=2)
    ax[1,1].plot(x,avg_fss_maple144[5,i,:],label='L = ' +(str( '%2.0f' %round(leng[i]*110*0.0125)))+' km',linewidth=2)
    ax[2,1].plot(x,avg_fss_maple144[7,i,:],label='L = ' +(str( '%2.0f' %round(leng[i]*110*0.0125)))+' km',linewidth=2)
    
for i in range(len(avg_fss_com[0,:,0])-3):
    ax[0,2].plot(x,avg_fss_com[1,i,:],label='L = ' +(str( '%2.0f' %round(leng[i]*110*0.0125)))+' km',linewidth=2)
    ax[1,2].plot(x,avg_fss_com[5,i,:],label='L = ' +(str( '%2.0f' %round(leng[i]*110*0.0125)))+' km',linewidth=2)
    ax[2,2].plot(x,avg_fss_com[7,i,:],label='L = ' +(str( '%2.0f' %round(leng[i]*110*0.0125)))+' km',linewidth=2)
    '''
for i in range(len(avg_fss_wrf[0,:,0])-1):
    ax[0,3].plot(x,avg_fss_wrf[5,i,:],label='L = ' +(str( '%2.0f' %round(leng[i]*110*0.0125)))+' km',linewidth=2)
    ax[1,3].plot(x,avg_fss_wrf[6,i,:],label='L = ' +(str( '%2.0f' %round(leng[i]*110*0.0125)))+' km',linewidth=2)
    ax[2,3].plot(x,avg_fss_wrf[7,i,:],label='L = ' +(str( '%2.0f' %round(leng[i]*110*0.0125)))+' km',linewidth=2)
    '''
ref=np.zeros((8,25))

for i,j in zip(range(3),[1,5,7]):
    ref[:,]=avg_fss_ref_maple48[j]
    line1, =ax[i,0].plot(x,ref[j,:],c='black',linewidth=2)
    line1.set_dashes([1,1])
    
    ref[:,]=avg_fss_ref_maple144[j]
    line1, =ax[i,1].plot(x,ref[j,:],c='black',linewidth=2)
    line1.set_dashes([1,1])
    
    ref[:,]=avg_fss_ref_com[j]
    line1, =ax[i,2].plot(x,ref[j,:],c='black',linewidth=2)
    line1.set_dashes([1,1])
'''
    ref[:,]=avg_fss_ref_wrf[i+5]
    line1, =ax[i,3].plot(x,ref[i+5,:],c='black',linewidth=2)
    line1.set_dashes([1,1])
'''

ax[0,0].set_title('MAPLE48',size=15,bbox=dict(boxstyle='round',facecolor='cornflowerblue',alpha=0.3))
ax[0,1].set_title('MAPLE144',size=15,bbox=dict(boxstyle='round',facecolor='cornflowerblue',alpha=0.3))
ax[0,2].set_title('MAPLE_WRF',size=15,bbox=dict(boxstyle='round',facecolor='cornflowerblue',alpha=0.3))
#ax[0,3].set_title('WRF',size=15,bbox=dict(boxstyle='round',facecolor='cornflowerblue',alpha=0.3))

ax[1,2].legend(loc=2,bbox_to_anchor=(1.0,1.0),fontsize=15)
for j in range(3):
    for i in range(3):
        ax[i,j].set_xticks([0,6,12,18,24])
        ax[i,j].set_xlim(0,24)
        #ax[0].set_xlabel('Hour')
        ax[i,j].set_ylim(0,1)
        ax[i,j].set_xticklabels(['0','1','2','3','4'])
    
    
fig.text(0.01,0.5,'F S S',va='center',rotation='vertical',size=26,weight='heavy')
fig.text(0.4,0.01,'HOUR',va='center',size=24,weight='heavy')
#fig.text(0.015,0.943 ,'TH = 10 mm/h ',va='center',rotation=15,size=20,weight='semibold')
#fig.text(0.015,0.63 ,'TH = 20 mm/h ',va='center',rotation=15,size=20,weight='semibold')
#fig.text(0.015,0.32 ,'TH = 40 mm/h ',va='center',rotation=15,size=20,weight='semibold')


fig.suptitle(Case +' at  '+period,x=0.45,y=0.96,size=26,weight='heavy')
fig.subplots_adjust(top=0.90,bottom=0.05,left=0.07,right=0.82,wspace=0.3,hspace=0.15)



fig.show()
fig = plt.gcf()
fig.set_size_inches(12,12)
fig.savefig('/home/miayao/average/'+Case+'_fss_echo_rainfall_'+period+'_all_new.png',dpi=450)
            
###
