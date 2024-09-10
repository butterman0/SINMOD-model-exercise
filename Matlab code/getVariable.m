function field = getVariable(ncid, name, start, dims, layer, sample)
% ncid: NetCDF file ID
% name: variable name
% start: horizontal lower left grid coordinate of area to read
% dims: horizontal dimensions of area to read
% layer: layer to read
% sample: sample number

varid = netcdf.inqVarID(ncid, name);
% Read scale factor and offset, if any:
try
    scale = netcdf.getAtt(ncid, varid, 'scale_factor');
catch
    scale = 1;
end
try
    offset = netcdf.getAtt(ncid, varid, 'add_offset');
catch 
    offset = 0;
end
% Check what value indicates land points:
fillVal = netcdf.getAtt(ncid, varid, '_FillValue');
% Start and size arguments:
if isempty(layer)
    if isempty(sample)
        ss = [start(1) start(2)];
        dd = [dims(1) dims(2)];
    else
        ss = [start(1) start(2) sample];
        dd = [dims(1) dims(2) 1];
    end
else
    if isempty(sample)
        ss = [start(1) start(2) layer];
        dd = [dims(1) dims(2) 1];
    else
        ss = [start(1) start(2) layer sample];
        dd = [dims(1) dims(2) 1 1];
    end
    
end

% Read field:
field = netcdf.getVar(ncid, varid, ss, dd,'double');
% Check which elements are land points:
fillInds = field==fillVal;
% Apply offset and scaling:
field = offset + scale*double(field);
% Set all land points to NaN:
field(fillInds) = NaN;
