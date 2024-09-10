import numpy as np
import matplotlib.pyplot as plt
from netCDF4 import Dataset
from getVariable import get_variable
from getVariable import get_time_series
from plotWithContours import plot_with_contours
from density import dens
from getProfile import getProfile

# Enter correct path to data set:
filename = 'dataset.nc'

# Open file:
ncid = Dataset(filename, 'r')

# Variable names: time, LayerDepths, depth, elevation, temperature, 
# salinity, u-velocity, v-velocity, w-velocity, u-wind, v-Wind

cvals = [100, 250, 500]

LayerDepths = ncid.variables['LayerDepths'][:]

# Read bathymetry field:
depth = get_variable(filename, 'depth', [0, 0], [350, 400], [], [])

# Read layer from 3d field:
u = get_variable(filename, 'u-velocity', [0, 0], [350, 400], 10, 30)
v = get_variable(filename, 'v-velocity', [0, 0], [350, 400], 10, 30)
S = get_variable(filename, 'salinity', [0, 0], [350, 400], 0, 0)
T = get_variable(filename, 'temperature', [0, 0], [350, 400], 0, 0) - 273.15
# Read from 2d field:
e = get_variable(filename, 'elevation', [0, 0], [350, 400], [], 0)

S_open = getProfile(filename, 'salinity', [200, 250], 10)
spd_open = np.sqrt(getProfile(filename, 'u-velocity', [200, 250], 10)**2 + \
    getProfile(filename, 'v-velocity', [200, 250], 10)**2)
S_TrF = getProfile(filename, 'salinity', [210, 25], 10)
spd_TrF = np.sqrt(getProfile(filename, 'u-velocity', [210, 25], 10)**2 + \
    getProfile(ncid, 'v-velocity', [210, 25], 10)**2)

t, e_timeseries = get_time_series(filename, 'elevation', [125, 175], 1)
t, T_timeseries = get_time_series(filename, 'temperature', [125, 175], 1)

# Close file:
ncid.close()

# Plot time series:
plt.figure()
plt.plot(t, e_timeseries)

rho = dens(S, T)

plot_with_contours(rho, None, depth, 5, cvals)
plot_with_contours(u, v, depth, 5, cvals, h)

ncid = Dataset(filename, 'r')
u_avg = np.zeros((350, 400))
v_avg = np.zeros((350, 400))
for i in range(len(t)):
    print(i)
    u = get_variable(filename, 'u-velocity', [0, 0], [350, 400], 10, i-1)
    v = get_variable(filename, 'v-velocity', [0, 0], [350, 400], 10, i-1)
    u_avg += u
    v_avg += v
ncid.close()

u_avg /= len(t)
v_avg /= len(t)

h = plt.figure(figsize=(15, 11))
plot_with_contours(u_avg, v_avg, depth, 5, cvals, h)
plt.clim(0, 0.45)

plt.figure()
plt.plot(t, T_timeseries - 273.15)

zcoord = np.cumsum(LayerDepths) - 0.5 * LayerDepths
fig, axs = plt.subplots(2, 2)

axs[0, 0].plot(S_open, zcoord)
axs[0, 0].invert_yaxis()
axs[0, 0].grid(True)
axs[0, 0].set(xlabel='Salinity', ylabel='Depth (m)')

axs[0, 1].plot(S_TrF, zcoord)
axs[0, 1].invert_yaxis()
axs[0, 1].grid(True)
axs[0, 1].set(xlabel='Salinity', ylabel='Depth (m)')

axs[1, 0].plot(spd_open, zcoord)
axs[1, 0].invert_yaxis()
axs[1, 0].grid(True)
axs[1, 0].set(xlabel='Current speed', ylabel='Depth (m)')

axs[1, 1].plot(spd_TrF, zcoord)
axs[1, 1].invert_yaxis()
axs[1, 1].grid(True)
axs[1, 1].set(xlabel='Current speed', ylabel='Depth (m)')

plt.show()
