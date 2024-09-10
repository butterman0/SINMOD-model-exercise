function [value] = getProfile(ncid, name, position, sample)
% [value] = getProfile(ncid, name, position, sample)
%
% ncid: NetCDF file ID
% name: variable name
% position: x,y position to read
% sample: sample number to read

% Get z dimension:
[~, zlen] = netcdf.inqDim(ncid,netcdf.inqDimID(ncid,'zc'));

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
ss = [position(1) position(2) 0 sample];
dd = [1 1 zlen 1];

% Read field:
value = netcdf.getVar(ncid, varid, ss, dd,'double');
fillV = value == fillVal;
% Apply offset and scaling:
value = offset + scale*double(value);
value = permute(value, [3 1 2]);
value(fillV) = NaN;