% Representation Maps
clear all
clc
ruta_SH='P:\codigo\Result_ERA5\Diciembre';

addpath(ruta_SH)
data= dir([ruta_SH,'\SM HR*']);

z=length(data);

for i=1:z
data1=load(data(i,1).name);
SM_HR(:,:,i)=data1.sm_HR;
%SM=data1.sm_HR;
lon=data1.lon_aux;
lat=data1.lat_aux;
end

SM=NaN(length(lat),length(lon));
for j=1:length(lat)
    for k=1:length(lon)
       SM(j,k)=nanmean(SM_HR(j,k,:));
    end
end

 save('SM_ERA5_12.mat','SM','lon','lat');

colormap(b2r(-6,8)), colorbar,

h=figure(1)
imagesc(lon,lat, SM,'AlphaData',~isnan(SM),'AlphaDataMapping','none')
axis xy; axis equal, colorbar, caxis([0,0.3]);
colordata = colormap(jet);
colormap(colordata);
colormap(flipud(colormap));

xlabel('LON');
ylabel('LAT'); 
title('SM_H - Adaptive Window Method -Diciembre-ERA5');


