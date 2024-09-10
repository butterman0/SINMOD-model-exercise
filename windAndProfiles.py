import numpy as np
import matplotlib.pyplot as plt
from netCDF4 import Dataset

# Enter correct path to data set:
filename = 'E:/nn9828k/spring2021/mids_short/dataset.nc'

# Open file:
ncid = Dataset(filename, 'r')

# Variable names: time, LayerDepths, depth, elevation, temperature, 
# salinity, u-velocity, v-velocity, w-velocity, u-Wind, v-Wind

#pos = [200, 300]
pos = [200, 250]
sample = 119+24

LayerDepths = ncid.variables['LayerDepths'][:]

# Assuming getTimeSeries and getProfile are defined
t, u_ts = getTimeSeries(ncid, 'u-velocity', pos, 0)
t, v_ts = getTimeSeries(ncid, 'v-velocity', pos, 0)
spd_ts = np.sqrt(u_ts**2 + v_ts**2)
t, u_ts2 = getTimeSeries(ncid, 'u-velocity', pos, 10)
t, v_ts2 = getTimeSeries(ncid, 'v-velocity', pos, 10)
spd_ts2 = np.sqrt(u_ts2**2 + v_ts2**2)
t, uw_ts = getTimeSeries(ncid, 'u-wind', pos, [])
t, vw_ts = getTimeSeries(ncid, 'v-Wind', pos, [])
spd_w_ts = np.sqrt(uw_ts**2 + vw_ts**2)

S = getProfile(ncid, 'salinity', pos, sample)
T = getProfile(ncid, 'temperature', pos, sample)
u = getProfile(ncid, 'u-velocity', pos, sample)
v = getProfile(ncid, 'v-velocity', pos, sample)
spd = np.sqrt(u**2 + v**2)
direc = np.arctan2(v, u)
direc[direc<0] = direc[direc<0]+2*np.pi
uw = getVariable(ncid, 'u-wind', pos, [1, 1], [], sample)
vw = getVariable(ncid, 'v-Wind', pos, [1, 1], [], sample)

wspd = np.sqrt(uw**2 + vw**2)
wdirec = np.arctan2(uw, vw)
wdirec[wdirec<0] = wdirec[wdirec<0]+2*np.pi

# Close file:
ncid.close()

zcoord = np.cumsum(LayerDepths) - 0.5*LayerDepths
fig, axs = plt.subplots(2, 2)

axs[0, 0].plot(S, zcoord)
axs[0, 0].invert_yaxis()
axs[0, 0].grid(True)
axs[0, 0].set(xlabel='Salinity', ylabel='Depth (m)')

axs[0, 1].plot(T, zcoord)
axs[0, 1].invert_yaxis()
axs[0, 1].grid(True)
axs[0, 1].set(xlabel='Temperature', ylabel='Depth (m)')

axs[1, 0].plot(spd, zcoord)
axs[1, 0].invert_yaxis()
axs[1, 0].grid(True)
axs[1, 0].set(xlabel='Speed', ylabel='Depth (m)')

axs[1, 1].plot(direc*180/np.pi, zcoord)
axs[1, 1].invert_yaxis()
axs[1, 1].grid(True)
axs[1, 1].set(xlabel='Direction', ylabel='Depth (m)')
axs[1, 1].plot(wdirec*180/np.pi, 0, 'k*')

plt.show()
