clear all
 
  Name_data='ERAINTERIM';   % ERAINTERIM 83Km
  
 ruta='P:\codigo\ERA';
 name_ERA=dir([ruta,'\',Name_data,'*']);
 
% ruta='C:\Users\Khalid\Desktop\Matlab_TFG\ERA&INREIN&MODIS mapa\ERA5';
% name_ERA=dir([ruta,'\ERA5_2015_january*']);
addpath(ruta)

for l=1:length(name_ERA)
    mes_str=num2str(l);
info=ncinfo(name_ERA(l,1).name);
SF_skt=info.Variables(4).Attributes(1).Value;
offset_skt=info.Variables(4).Attributes(2).Value;
  ncid = netcdf.open(name_ERA(l,1).name,'NC_NOWRITE');
  
  varid = netcdf.inqVarID(ncid,'latitude');
  lat_ERA(:,1)=netcdf.getVar(ncid,varid)';
%  
  varid = netcdf.inqVarID(ncid,'longitude');
  lon_ERA(1,:)=(netcdf.getVar(ncid,varid))';
  varid = netcdf.inqVarID(ncid,'skt');
  skt_ERA=SF_skt*(netcdf.getVar(ncid,varid))+offset_skt;
   netcdf.close(ncid);
  for i=1:length(skt_ERA(1,1,:))
  skt=skt_ERA(:,:,i);
   skt= double(skt);
   skt(skt==0)= NaN;
   skt=flipud(rot90(skt));
   
   % Aplicamos la mascara  
   
   x1 =  min(lon_ERA); x2 = max(lon_ERA); y1 = max(lat_ERA); y2 = min(lat_ERA);
   
   load earthmap
 lon_etopo5 = earthmap.lon;
 lat_etopo5 = earthmap.lat;
coast      = earthmap.map;
 coast(coast == 255) = 1; %sea
 coast(coast == 230) = 0; %land
% 
 lat_coast = lat_etopo5(lat_etopo5 >= y2 & lat_etopo5 <= y1);
 lon_coast = lon_etopo5(lon_etopo5 >= x1 & lon_etopo5 <= x2);
 ok_coast  = coast(lat_etopo5 >= y2 & lat_etopo5 <= y1, lon_etopo5 >= x1 & lon_etopo5 <= x2);
% 
 coast_aux = interp2(lon_coast,lat_coast,double(ok_coast),lon_ERA,lat_ERA,'linear');
 dist_coast = bwdist(coast_aux);
 mask_coast_LR= dist_coast;

%Me meto dos píxeles hacia dentro del mar
 mask_coast_LR(mask_coast_LR>=1)=1;
 mask_coast_LR= bwdist(mask_coast_LR);
 mask_coast_LR(mask_coast_LR<=1)=1;
 mask_coast_LR(mask_coast_LR>1)=NaN;
%save('Mask_Coast_LR.mat','mask_coast_LR');
   
   % el codigo de arriba es para la mascara 
 
 %mask_skt(mask_skt~=1)=0;
% mask_coast_LR(isnan)=0;
 skt=skt.*mask_coast_LR;
  skt(skt==0)= NaN;
  dia_str=num2str(i);
  
  h=figure(1);
imagesc(lon_ERA,lat_ERA,skt,'AlphaData',~isnan(skt),'AlphaDataMapping','none')
axis xy; axis equal, colorbar, caxis([270,300]);
colordata = colormap(jet);
colormap(colordata);
%colormap(flipud(colormap));
xlabel('LON');
ylabel('LAT'); 
title('Skt - temperature of ERAINTERIM');
  
  
 name_save= ['ERA_skt - ','2015-',mes_str,'-', dia_str];
% save(name_save,'skt','lat_ERA','lon_ERA')
  end
  i=length(name_ERA);
end


% h=figure(1);
% imagesc(lon_ERA5,lat_ERA5,skt_01,'AlphaData',~isnan(skt_01),'AlphaDataMapping','none')
% axis xy; axis equal, colorbar, caxis([270,300]);
% colordata = colormap(jet);
% colormap(colordata);
% colormap(flipud(colormap));
% xlabel('LON');
% ylabel('LAT'); 
% title('Skt - temperature of ERA5');
% end