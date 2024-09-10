
function plotWithContours(fieldU, fieldV, depth, subs, cvals, h)
% plotWithContours(fieldU, fieldV, depth, subs, cvals)
%
% Plots a color map of current speed overlaid with arrows indicating
% current speed and direction, and selected bathymetry contours.
% If second component is empty, the first component is plotted as a scalar
% field (with no arrow plot).
%
% fieldU: the U current components
% fieldV: the V current components. If empty, fieldU will be plotted as a
%   scalar field.
% depth: the bathymetry field
% subs: indicates the subsetting for plotting arrows (every 'subs' grid
%   point is plotted)
% cvals: list of depth contours to include
% h: figure handle to plot to. If not included, a new figure will be opened.

if isempty(fieldV)
    spd = fieldU;
    plotArrows = 0;
else
    spd = sqrt(fieldU.^2 + fieldV.^2);
    plotArrows = 1;
end

if nargin>=6
    figure(h), hold off
else
    figure
end

pcolor(spd'), shading flat, hold on;
if plotArrows > 0
    [X,Y] = meshgrid(1:size(fieldU,1),1:size(fieldU,2));
    quiver(X(1:subs:end,1:subs:end), Y(1:subs:end,1:subs:end), ...
        fieldU(1:subs:end,1:subs:end)', fieldV(1:subs:end,1:subs:end)','k')
end
cax = caxis;
set(gca,'color',[0.7 0.7 0.7]);
[c,h] = contour(depth', cvals,'color',[1 1 1]);
caxis(cax), colorbar




