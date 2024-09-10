function [time, series] = getVariable(ncid, name, position, layer, t_start, t_length)
% [time, series] = getVariable(ncid, name, position, layer, t_start, t_length)
%
% ncid: NetCDF file ID
% name: variable name
% position: x,y position to read
% layer: layer to read
% t_start (optional): first sample to include
% t_length (optional): number of samples to include

% Get time dimension:
[~, timelen] = netcdf.inqDim(ncid,netcdf.inqDimID(ncid,'time'));

if nargin <= 4
    t_start = 0;
    t_length = timelen;
end

time = netcdf.getVar(ncid, netcdf.inqVarID(ncid, 'time'), t_start, t_length);

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



% Start and size arguments:
if isempty(layer)
    ss = [position(1) position(2) t_start];
    dd = [1 1 timelen];
else
    ss = [position(1) position(2) layer t_start];
    dd = [1 1 1 timelen];
end

% Read field:
series = netcdf.getVar(ncid, varid, ss, dd,'double');
% Apply offset and scaling:
series = offset + scale*double(series);

if isempty(layer)
    series = permute(series, [3 1 2]);
else
    series = permute(series, [4 1 2 3]);
end