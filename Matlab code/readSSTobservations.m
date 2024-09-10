% File with observation data:
filename = 'obs_sst_ttk17.nc';

% Read time, sst and standard deviations from file (using Matlab's
% simplified NetCDF functions):
time = ncread(filename,'time');
sst = ncread(filename,'sst') - 273.15;
sst_stdev = ncread(filename,'sst_stdev');

% % Read reference time:
% refTimeString = ncreadatt(filename,'time','units');
% refTime = datenum(refTimeString(12:end), 'yyyy-mm-dd');
% time = time + refTime;

cax = [2 9];

% Read SINMOD data:
sFilename = 'E:/nn9828k/spring2021/mids_short/dataset.nc';
ncid = netcdf.open(sFilename);
T = getVariable(ncid, 'temperature', [0 0], [400 350], 0, 0)-273.15;
netcdf.close(ncid);


figure
subplot(2,2,1), pcolor(sst(:,:,1)'), shading flat, colorbar, caxis(cax)
subplot(2,2,2), pcolor(T'), shading flat, colorbar, caxis(cax)
subplot(2,2,3), pcolor(sst_stdev(:,:,1)'), shading flat, colorbar
