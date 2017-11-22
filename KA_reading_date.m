clear all
%orbita='A';
 name='skt';

ruta='C:\Users\Khalid\Desktop\Matlab_TFG\Simolacion 1\CATDS data';
%name_NRTS=dir([ruta_NRTS,'\NRTSM001D025A_BEC_BIN_SM_A_2017*']');
 name_ERA5=dir([ruta,'\05032015_temp*']);
addpath(ruta)
info=ncinfo(name_ERA5.name);
SF_skt=info.Variables(5).Attributes(1).Value;
offset_skt=info.Variables(5).Attributes(2).Value;
  ncid = netcdf.open(name_ERA5.name,'NC_NOWRITE');
  
  varid = netcdf.inqVarID(ncid,'latitude');
  lat_ERA5(:,1)=netcdf.getVar(ncid,varid)';
%  
  varid = netcdf.inqVarID(ncid,'longitude');
  lon_ERA5(1,:)=(netcdf.getVar(ncid,varid))';
  SM_ERA5=KA_variable_necdtf(ncid,SF_skt,offset_skt,name);
  netcdf.close(ncid);  
  z=length(SM_ERA5(1,1,:));
  cosr=load('coords');
  Lat=cosr.lat_smos;
  Long=cosr.lon_smos;
  mask=load('Mask_Coast_LR.mat');
mask=mask.mask_coast_LR;
for i=1:length(SM_ERA5(1,1,:))
  SM=SM_ERA5(:,:,i);
  SM=flipud(rot90(SM));
  
  
 
 SM_a= interp2(lon_ERA5,lat_ERA5,SM,Long,Lat,'linear');
% % 

%mask(isnan)=0;
SM_b=SM_a.*mask;
SM_B= interp2(Long,Lat,SM_b,lon_ERA5,lat_ERA5,'linear');
h=figure(i);
imagesc(lon_ERA5,lat_ERA5,SM_B,'AlphaData',~isnan(SM_B),'AlphaDataMapping','none')
axis xy; axis equal, colorbar, caxis([270,300]);
colordata = colormap(jet);
colormap(colordata);
colormap(flipud(colormap));
xlabel('LON');
ylabel('LAT'); 
title('Skt - temperature of ERA5');
end