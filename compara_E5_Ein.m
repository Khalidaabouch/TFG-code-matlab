clear 
clc


E50101=load('ERA5_skt - 2015-6-16.mat');
Eint0101=load('ERAINTERIM_skt - 2015-6-16.mat');

ERA5_skt=E50101.skt;
lat_ERA5=E50101.lat_ERA;
lon_ERA5=E50101.lon_ERA;


Ein_skt=Eint0101.skt;
lat_Ein=Eint0101.lat_ERA;
lon_Ein=Eint0101.lon_ERA;

Era5_83km=interp2(lon_ERA5,lat_ERA5,ERA5_skt,lon_Ein,lat_Ein,'linear');
Eraint_33km=interp2(lon_Ein,lat_Ein,Ein_skt,lon_ERA5,lat_ERA5,'linear');

Dif=Ein_skt - Era5_83km;
Dif2=ERA5_skt - Eraint_33km;
h=figure(1);
imagesc(lon_ERA5,lat_ERA5,Dif2,'AlphaData',~isnan(Dif2),'AlphaDataMapping','none')
axis xy; axis equal, colorbar, caxis([-1,1]);
colordata = colormap(jet);
colormap(colordata);
colormap(flipud(colormap));
xlabel('LON');
ylabel('LAT'); 
title('SM HR - Adaptive Window Method');
