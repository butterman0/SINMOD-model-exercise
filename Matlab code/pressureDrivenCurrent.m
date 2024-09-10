
% Inlet Trondheimsfjorden: 176, 56


% Enter correct path to data set:
filename = 'E:/nn9828k/spring2021/mids_short/dataset.nc';

% Open file:
ncid = netcdf.open(filename);

pos1 = [176 53];
pos2 = [176 56];
pos3 = [176 59];
% pos1 = [200 247];
% pos2 = [200 250];
% pos3 = [200 253];


[t, E_inner] = getTimeSeries(ncid, 'elevation', pos1, []);
[t, E_outer] = getTimeSeries(ncid, 'elevation', pos3, []);

[t, V] = getTimeSeries(ncid, 'v-velocity', pos2, 10);
[t, U] = getTimeSeries(ncid, 'u-velocity', pos2, 10);
[t, T] = getTimeSeries(ncid, 'temperature', pos2, 10);
[t, S] = getTimeSeries(ncid, 'salinity', pos2, 10);
[t, windV] = getTimeSeries(ncid, 'v-Wind', pos2, []);

V_acc = [0; diff(V)]/(86400*(t(2)-t(1)));


% Close file:
netcdf.close(ncid);

%%
g = 9.81;
rho_0 = 1023.6; % Density of seawater

% Find dE_dx:
dE_dx = (E_inner-E_outer)/(800*(pos3(2)-pos1(2)));
% Find pressure gradient:
dp_dx = rho_0*g*dE_dx;
% Find acceleration term: -(1/rho_0)*dp_dx
p_acc = dp_dx/rho_0;

figure, plot(t, [p_acc V_acc])
figure, plot(t, windV)
%%

figure, plot(t, [p_acc-V_acc 0.0001*U])
%%
figure, subplot(1,2,1), plot(t, [E2 - E1])
subplot(1,2,2), plot(t, V)

%%
figure, plot(V_acc, (E_inner-E_outer),'.')

%%
figure,plot(V,E_inner)
%%
figure, plot(t, [V_acc 5*(E_inner-E_outer)],'-')