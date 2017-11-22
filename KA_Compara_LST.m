% compara data 
clear
clc



ruta='C:\Users\khalid.aabouch\Desktop\ERA&INREIN&MODIS mapa\Comparar Code'; 
name_LST=dir([ruta,'\MYD11A1.A2015001_mosaic_geo*']);

info=ncinfo(name_LST.name);

 SF=info.Variables(4).Attributes(8).Value;
 ncid = netcdf.open(name_LST.name,'NC_NOWRITE');
  
  varid = netcdf.inqVarID(ncid,'latitude');
  lat_LST=netcdf.getVar(ncid,varid)';
%  
  varid = netcdf.inqVarID(ncid,'longitude');
  lon_LST=netcdf.getVar(ncid,varid);
  varid = netcdf.inqVarID(ncid,'LST_Day_1km');
  LST=netcdf.getVar(ncid,varid);
  LST=SF*netcdf.getVar(ncid,varid);
  LST=flipud(rot90(LST));
  LST(LST==0)=NaN;
  LST=double(LST);
  
   netcdf.close(ncid);
   
    load earthmap
   
 lon_etopo5 = earthmap.lon;
 lat_etopo5 = earthmap.lat;
 coast = earthmap.map;
 
 load('ERA5_skt - 2015-1-1.mat')
 
   
   Mask_LST=KA_apply_Mask(lon_LST,lat_LST,lon_etopo5,lat_etopo5,coast);
   Mask_ERA5=KA_apply_Mask(lon_ERA,lat_ERA,lon_etopo5,lat_etopo5,coast);
   
   LST_1km=LST.*Mask_LST;
   skt_33km=skt.*Mask_ERA5;
    LST_1km(LST_1km==0)=NaN;
    skt_33km(skt_33km==0)=NaN;
    
   LST_33km=interp2(lon_LST,lat_LST,LST_1km,lon_ERA,lat_ERA,'linear');
   
   
    h=figure(1);
imagesc(lon_LST,lat_LST,LST_33km,'AlphaData',~isnan(LST_33km),'AlphaDataMapping','none')
axis xy; axis equal, colorbar, caxis([270,300]);
colordata = colormap(jet);
colormap(colordata);
%colormap(flipud(colormap));
xlabel('LON');
ylabel('LAT'); 
title('Skt - temperature of ERAINTERIM');