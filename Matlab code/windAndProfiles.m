% Enter correct path to data set:
filename = 'E:/nn9828k/spring2021/mids_short/dataset.nc';

%%
% Open file:
ncid = netcdf.open(filename);

% Variable names: time, LayerDepths, depth, elevation, temperature, 
% salinity, u-velocity, v-velocity, w-velocity, u-Wind, v-Wind

%pos = [200 300];
pos = [200 250];
sample = 119+24;

LayerDepths = netcdf.getVar(ncid, netcdf.inqVarID(ncid, 'LayerDepths'));


[t, u_ts] = getTimeSeries(ncid, 'u-velocity', pos, 0);
[t, v_ts] = getTimeSeries(ncid, 'v-velocity', pos, 0);
spd_ts = sqrt(u_ts.^2 + v_ts.^2);
[t, u_ts2] = getTimeSeries(ncid, 'u-velocity', pos, 10);
[t, v_ts2] = getTimeSeries(ncid, 'v-velocity', pos, 10);
spd_ts2 = sqrt(u_ts2.^2 + v_ts2.^2);
[t, uw_ts] = getTimeSeries(ncid, 'u-wind', pos, []);
[t, vw_ts] = getTimeSeries(ncid, 'v-Wind', pos, []);
spd_w_ts = sqrt(uw_ts.^2 + vw_ts.^2);

S = getProfile(ncid, 'salinity', pos, sample);
T = getProfile(ncid, 'temperature', pos, sample);
u = getProfile(ncid, 'u-velocity', pos, sample);
v = getProfile(ncid, 'v-velocity', pos, sample);
spd = sqrt(u.^2 + v.^2);
direc = atan2(v, u);
direc(direc<0) = direc(direc<0)+2*pi;
uw = getVariable(ncid, 'u-wind', pos, [1 1], [], sample)
vw = getVariable(ncid, 'v-Wind', pos, [1 1], [], sample)

wspd = sqrt(uw.^2 + vw.^2);
wdirec = atan2(uw, vw);
wdirec(wdirec<0) = wdirec(wdirec<0)+2*pi;


% Close file:
netcdf.close(ncid);

%%

zcoord = cumsum(LayerDepths) - 0.5*LayerDepths;
figure, 
subplot(2,2,1), plot(S, zcoord), set(gca,'YDir','reverse'), grid on
xlabel('Salinity'), ylabel('Depth (m)')
subplot(2,2,2), plot(T, zcoord), set(gca,'YDir','reverse'), grid on
xlabel('Temperature'), ylabel('Depth (m)')
subplot(2,2,3), plot(spd, zcoord), set(gca,'YDir','reverse'), grid on
xlabel('Speed'), ylabel('Depth (m)')
%hold on, plot(wspd, 0, 'k *');
subplot(2,2,4), plot(direc*180/pi, zcoord), set(gca,'YDir','reverse'), grid on
xlabel('Direction'), ylabel('Depth (m)')
hold on, plot(wdirec*180/pi, 0, 'k *');