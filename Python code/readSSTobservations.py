import netCDF4 as nc
import matplotlib.pyplot as plt

# File with observation ds:
filename = 'obs_sst_ttk17.nc'

# Read time, sst and standard deviations from file
ds = nc.Dataset(filename)
time = ds.variables['time'][:]
sst = ds.variables['sst'][:] - 273.15
sst_stdev = ds.variables['sst_stdev'][:]

cax = [2, 9]

# Read SINMOD ds:
sFilename = 'dataset.nc'
ds_s = nc.Dataset(sFilename)
T = ds_s.variables['temperature'][0, 0] - 273.15

fig, axs = plt.subplots(2, 2)

# Plot sst
im1 = axs[0, 0].pcolor(sst[0, 0, :, :].T, cmap='jet', vmin=cax[0], vmax=cax[1])
fig.colorbar(im1, ax=axs[0, 0])

# Plot T
im2 = axs[0, 1].pcolor(T.T, cmap='jet', vmin=cax[0], vmax=cax[1])
fig.colorbar(im2, ax=axs[0, 1])

# Plot sst_stdev
im3 = axs[1, 0].pcolor(sst_stdev[0, 0, :, :].T, cmap='jet')
fig.colorbar(im3, ax=axs[1, 0])

plt.show()