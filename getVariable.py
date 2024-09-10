import numpy as np
import netCDF4 as nc

def get_variable(file_path, variable_name, position=None, layers=None, samples=None):
    """
    file_path: Path to the NetCDF file
    variable_name: variable variable_name
    start: horizontal lower left grid coordinate of area to read
    position: horizontal dimensions of area to read
    layer: layer to read. I.e. which depth or depths
    sample: sample number. I.e. which moment in time (or moments)
    """
    
    with nc.Dataset(file_path, 'r') as nc_file:

        # Get variable
        var = nc_file.variables[variable_name]

        # Get scaling and offset parameters
        scale_factor = var.scale_factor if hasattr(var, 'scale_factor') else 1.0
        offset = var.add_offset if hasattr(var, 'add_offset') else 0.0

        # If arguments are None, fetch the entire dimension
        position = (slice(None), slice(None)) if position is None else position
        layers = slice(None) if layers is None else layers
        samples = slice(None) if samples is None else samples

        # Slice the data based on number of dimension
        
        # If time
        if variable_name == "time":
            data_slice = var[samples]

        # If LayerDepths
        elif variable_name == "LayerDepths":
            data_slice = var[layers]

        # 2 dimensions: depth, DXxDYy, gridLats, gridLons. Only position.
        elif len(var.dimensions) == 2:
            data_slice = var[position[0], position[1]]
        
        # 3 dimensions: u-wind, v-wind, elevation. Only samples and position.
        elif len(var.dimensions) == 3:
            data_slice = var[samples, position[0], position[1]]

        # 4 dimensions: remaining variables
        else:
            data_slice = var[samples, layers, position[0], position[1]]
        
        # Convert the data slice to a numpy array
        data_slice = np.array(data_slice, dtype=float)

        # Handle _FillValue
        if hasattr(var, '_FillValue'):
            fill_value = var.getncattr('_FillValue')
            # If data_slice is an array, replace _FillValue with numpy.nan
            if isinstance(data_slice, np.ndarray):
                data_slice[data_slice == fill_value] = np.nan
        
        data_slice = data_slice * scale_factor + offset

        # TODO: Rearrange variables in data slice to match function argument order

    return data_slice