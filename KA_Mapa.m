% Representation Maps
clear all
clc
    % Resultado ERA5
 ruta_SH= 'C:\Users\khalid.aabouch\Desktop\ERA&INREIN&MODIS mapa\ERA_Code\Result_ERA5\Febrero';

    % Resultado ERAINTERIM
 %ruta_SH= 'C:\Users\Khalid\Desktop\Matlab_TFG\ERA&INREIN&MODIS mapa\New Version\Result_SM_ERAINTERIM_83km'; 
%    ruta_SH= 'C:\Users\Khalid\Desktop\Matlab_TFG\ERA&INREIN&MODIS mapa\New Version\Result_SM_ERAINTERIM';
    % Resultado MODIS
% ruta_SH= 'C:\Users\khalid.aabouch\Desktop\ERA&INREIN&MODIS mapa\ERA_Code\Resutl_ERAINTERIM\Diciembre';
%ruta_SH='C:\Users\khalid.aabouch\Desktop\ERA&INREIN&MODIS mapa\New Version\Result_SM_ERAINTERIM';

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
SM(SM==0)=NaN;

h=figure(1)
imagesc(lon,lat, SM,'AlphaData',~isnan(SM),'AlphaDataMapping','none')
axis xy; axis equal, colorbar, caxis([0,0.3]);
colordata = colormap(jet);
colormap(colordata);
colormap(flipud(colormap));

xlabel('LON');
ylabel('LAT'); 
title(['SM_H - Adaptive Window Method ERA5 Febrero']);


