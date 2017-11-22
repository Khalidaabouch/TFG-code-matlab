clear
clc


Ins1='MODIS';
Ins2='ERA5';
Ins3='ERAINTERIM';
Mes='01';




% Modis=load('SM_MODIS_Agosto.mat');
% Erain=load('SM_ERAINTERIM_Agosto.mat');
ruta='P:\codigo\Resultado_Mensual';
addpath(ruta)

data_1= dir([ruta,'\SM_',Ins1,'_',Mes,'*']);
data_2= dir([ruta,'\SM_',Ins2,'_',Mes,'*']);
data_3= dir([ruta,'\SM_',Ins3,'_',Mes,'*']);

data0=dir([ruta,'\SM25km_2015-01*']);
%data_1= load(ruta,[ruta,'\SM_',Ins1,'_',Mes,'*']);


[SM1,lat1,lon1]=KA_load_mat(data_1); % SM .mat de MODIS
[SM2,lat2,lon2]=KA_load_mat(data_2); % SM '.mat' de ERA5
[SM3,lat3,lon3]=KA_load_mat(data_3);

A=load(data0.name);
SM0=A.SM25km_M;
lat0=A.lat_smos;
lon0(1,:)=A.lon_smos;


SM1_25=interp2(lon1,lat1,SM1,lon0,lat0,'linear');
SM2_25=interp2(lon2,lat2,SM2,lon0,lat0,'linear');
SM3_25=interp2(lon3,lat3,SM3,lon0,lat0,'linear');


Dif1=SM1_25-SM0;
Dif2=SM2_25-SM0;
Dif3=SM3_25-SM0;

SDif1=Dif1;
SDif2=Dif2;
SDif3=Dif3;

SDif1(isnan(SDif1))=0;
SDif2(isnan(SDif2))=0;
SDif3(isnan(SDif3))=0;

S1=num2str(std(std(SDif1)));
S2=num2str(std(std(SDif2)));
S3=num2str(std(std(SDif3)));

%SM1_25=interp2(lon3,lat3,SM1,lon1,lat1,'linear');
%SM1_25km    = interp2(lon,lat_aux,NDVI,lon_smos,lat_smos,'linear');




figure(1)
subplot(1,3,1)
imagesc(lon1,lat1,SM1,'AlphaData',~isnan(SM1),'AlphaDataMapping','none')
axis xy; axis equal, colorbar,  caxis([0,0.3]);
colordata = colormap(jet);
colormap(colordata);
colormap(flipud(colormap));
xlabel('LON');
ylabel('LAT'); 
title('Enero 2015 MODIS 1Km');



% histogram(SM0);
% title('Histograma L3 25Km ENERO 2015');

subplot(1,3,2)
imagesc(lon2,lat2,SM2,'AlphaData',~isnan(SM2),'AlphaDataMapping','none')
axis xy; axis equal, colorbar,  caxis([0,0.3]);
colordata = colormap(jet);
colormap(colordata);
colormap(flipud(colormap));
xlabel('LON');
ylabel('LAT'); 
title('Enero 2015 ERA5 1Km');

subplot(1,3,3)
imagesc(lon1,lat1,SM1,'AlphaData',~isnan(SM1),'AlphaDataMapping','none')
axis xy; axis equal, colorbar,  caxis([0,0.3]);
colordata = colormap(jet);
colormap(colordata);
colormap(flipud(colormap));
xlabel('LON');
ylabel('LAT'); 
title('Enero 2015 ERAINTERIM 1Km');


figure(2)
subplot(2,3,1)
histogram(Dif1);
%text(1500,0.08,'\sigma=');
xlim([-0.1 0.1]);
title('Histograma SM-MODIS&L3 25Km');

subplot(2,3,2)
histogram(Dif2);
xlim([-0.1 0.1]);
title('Histograma SM-ERA5&L3 25Km');

subplot(2,3,3)
histogram(Dif3);
xlim([-0.1 0.1]);
title('Histograma SM-ERAINTERIM&L3 25Km');


subplot(2,3,4)
imagesc(lon1,lat1,Dif1,'AlphaData',~isnan(Dif1),'AlphaDataMapping','none')
axis xy; axis equal, colormap(b2r(-0.1,0.1)), colorbar,
% colorbar, b2r(-0.1,0.1);% caxis([-0.1,0.1]);
% colordata = colormap(jet);
% colormap(colordata);
% colormap(flipud(colormap));
xlabel('LON');
ylabel('LAT'); 
title('Diferencia SM-MODIS&L3 25Km');

subplot(2,3,5)
imagesc(lon1,lat1,Dif2,'AlphaData',~isnan(Dif2),'AlphaDataMapping','none')
axis xy; axis equal, colormap(b2r(-0.1,0.1)), colorbar,
% colorbar, b2r(-0.1,0.1);% caxis([-0.1,0.1]);
% colordata = colormap(jet);
% colormap(colordata);
% colormap(flipud(colormap));
xlabel('LON');
ylabel('LAT'); 
title('Diferencia SM-ERA5&L3 25Km');

subplot(2,3,6)
imagesc(lon1,lat1,Dif3,'AlphaData',~isnan(Dif3),'AlphaDataMapping','none')
axis xy; axis equal, colormap(b2r(-0.1,0.1)), colorbar,
% colorbar, b2r(-0.1,0.1);% caxis([-0.1,0.1]);
% colordata = colormap(jet);
% colormap(colordata);
% colormap(flipud(colormap));
xlabel('LON');
ylabel('LAT'); 
title('Diferencia SM-ERAINTERIM&L3 25Km');







% % 
% h=figure(4);
% imagesc(lon1,lat1,Dif,'AlphaData',~isnan(Dif),'AlphaDataMapping','none')
% axis xy; axis equal, colorbar, % caxis([-0.1,0.1]);
% 
% newmap = b2r(-0.1,0.1);
% %colordata = colormap(bone);
% %colormap(colordata);
% %colormap(flipud(colormap));
% xlabel('LON');
% ylabel('LAT'); 
% title('Diferencia SM_ERA5&L3 25Km');







