from netCDF4 import Dataset
import numpy as np

def getProfile(file_path, name, position, sample):
    """
    ncid: NetCDF file ID
    name: variable name
    position: x,y position to read
    sample: sample number to read
    """
    # Open the NetCDF file
    ncfile = Dataset(file_path, 'r')

    # Get z dimension
    zlen = len(ncfile.dimensions['zc'])

    # Read scale factor and offset, if any
    try:
        scale = ncfile.variables[name].getncattr('scale_factor')
    except AttributeError:
        scale = 1

    try:
        offset = ncfile.variables[name].getncattr('add_offset')
    except AttributeError:
        offset = 0

    # Check what value indicates land points
    fillVal = ncfile.variables[name].getncattr('_FillValue')

    # Start and size arguments
    ss = (position[0], position[1], 0, sample)
    dd = (1, 1, zlen, 1)

    # Read field
    value = ncfile.variables[name][ss[0]:ss[0]+dd[0], ss[1]:ss[1]+dd[1], ss[2]:ss[2]+dd[2], ss[3]:ss[3]+dd[3]]
    fillV = value == fillVal

    # Apply offset and scaling
    value = offset + scale * value.astype(float)
    value = np.transpose(value, (2, 0, 1))
    value[fillV] = np.nan

    return value
