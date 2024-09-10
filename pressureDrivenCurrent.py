from netCDF4 import Dataset
from getVariable import get_variable
import numpy as np
import matplotlib.pyplot as plt

filename = 'dataset.nc'
ncid = Dataset(filename, 'r')

# Define positions
pos1 = (176, 53)
pos2 = (176, 56)
pos3 = (176, 59)
pos1 = (200, 247)
pos2 = (200, 250)
pos3 = (200, 253)


# Extracting data
t, E_inner = get_variable(filename, 'elevation', pos1)
t, E_outer = get_variable(filename, 'elevation', pos3)
t, V = get_variable(filename, 'v-velocity', pos2, 10)
t, U = get_variable(filename, 'u-velocity', pos2, 10)
t, T = get_variable(filename, 'temperature', pos2, 10)
t, S = get_variable(filename, 'salinity', pos2, 10)
t, windV = get_variable(filename, 'v-Wind', pos2)

# Calculate V acceleration
V_acc = np.diff(V) / (86400 * (t[1] - t[0]))

ncid.close()

g = 9.81
rho_0 = 1023.6  # Density of seawater

# Calculating dE_dx and pressure gradient
dE_dx = (E_inner - E_outer) / (800 * (pos3[1] - pos1[1]))
dp_dx = rho_0 * g * dE_dx

# Calculating acceleration term
p_acc = dp_dx / rho_0

# Plotting
plt.figure()
plt.plot(t, p_acc, label='p_acc')
plt.plot(t[1:], V_acc, label='V_acc')
plt.legend()
plt.show()

plt.figure()
plt.plot(t, windV)
plt.show()

# Additional plots can be created following the same pattern
