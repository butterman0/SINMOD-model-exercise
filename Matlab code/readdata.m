% Enter correct path to data set:
filename = 'E:/nn9828k/spring2021/mids_short/dataset.nc';

%%
% Open file:
ncid = netcdf.open(filename);

% Variable names: time, LayerDepths, depth, elevation, temperature, 
% salinity, u-velocity, v-velocity, w-velocity, u-wind, v-Wind

cvals = [100 250 500];

LayerDepths = netcdf.getVar(ncid, netcdf.inqVarID(ncid, 'LayerDepths'));

% Read bathymetry field:
depth = getVariable(ncid, 'depth', [0 0], [400 350], [], []);

% Read layer from 3d field:
u = getVariable(ncid, 'u-velocity', [0 0], [400 350], 10, 30);
v = getVariable(ncid, 'v-velocity', [0 0], [400 350], 10, 30);
S = getVariable(ncid, 'salinity', [0 0], [400 350], 0, 0);
T = getVariable(ncid, 'temperature', [0 0], [400 350], 0, 0)-273.15;
% Read from 2d field:
e = getVariable(ncid, 'elevation', [0 0], [400 350], [], 0);

S_open = getProfile(ncid, 'salinity', [200 250], 10);
spd_open = sqrt(getProfile(ncid, 'u-velocity', [200 250], 10).^ + ...
    getProfile(ncid, 'v-velocity', [200 250], 10).^2);
S_TrF = getProfile(ncid, 'salinity', [210 25], 10);
spd_TrF = sqrt(getProfile(ncid, 'u-velocity', [210 25], 10).^ + ...
    getProfile(ncid, 'v-velocity', [210 25], 10).^2);


[t, e_timeseries] = getTimeSeries(ncid, 'elevation', [175 125], []);
[t, T_timeseries] = getTimeSeries(ncid, 'temperature', [175 125], 1);


% Close file:
netcdf.close(ncid);

%%

% Plot time series:
figure, plot(t, e_timeseries)
%%

rho = dens(S,T);

plotWithContours(rho, [], depth, 5, cvals);
%%
plotWithContours(u, v, depth, 5, cvals, h);

%%
ncid = netcdf.open(filename);
u_avg = zeros(400,350);
v_avg = zeros(400,350);
for i=1:length(t)
    i
    u = getVariable(ncid, 'u-velocity', [0 0], [400 350], 10, i-1);
    v = getVariable(ncid, 'v-velocity', [0 0], [400 350], 10, i-1);
    u_avg = u_avg + u;
    v_avg = v_avg + v;
end
netcdf.close(ncid);

u_avg = u_avg/length(t);
v_avg = v_avg/length(t);

h = figure('Renderer', 'painters', 'Position', [10 10 1500 1100])
plotWithContours(u_avg, v_avg, depth, 5, cvals, h);
caxis([0 0.45])
%colormap(RedBlueInv)

%%
figure, plot(t, T_timeseries-273.15)

%%
zcoord = cumsum(LayerDepths) - 0.5*LayerDepths;
figure, 
subplot(2,2,1), plot(S_open, zcoord), set(gca,'YDir','reverse'), grid on
xlabel('Salinity'), ylabel('Depth (m)')
subplot(2,2,2), plot(S_TrF, zcoord), set(gca,'YDir','reverse'), grid on
xlabel('Salinity'), ylabel('Depth (m)')
subplot(2,2,3), plot(spd_open, zcoord), set(gca,'YDir','reverse'), grid on
xlabel('Current speed'), ylabel('Depth (m)')
subplot(2,2,4), plot(spd_TrF, zcoord), set(gca,'YDir','reverse'), grid on
xlabel('Current speed'), ylabel('Depth (m)')
