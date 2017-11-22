clear all
%orbita='A';
% name='Skin temperature';

ruta='C:\Users\Khalid\Desktop\Matlab_TFG\ERA&INREIN&MODIS mapa\ERAINTERIN';
%name_NRTS=dir([ruta_NRTS,'\NRTSM001D025A_BEC_BIN_SM_A_2017*']');
 name_ERAINTERIM=dir([ruta,'\ERAINTERIM_2015_January*']);
addpath(ruta)
info=ncinfo(name_ERAINTERIM.name);
SF_skt=info.Variables(4).Attributes(1).Value;
offset_skt=info.Variables(4).Attributes(2).Value;
  ncid = netcdf.open(name_ERAINTERIM.name,'NC_NOWRITE');
  
  varid = netcdf.inqVarID(ncid,'latitude');
  lat_ERAINTERIM(:,1)=netcdf.getVar(ncid,varid)';
%  
  varid = netcdf.inqVarID(ncid,'longitude');
  lon_ERAINTERIM(1,:)=(netcdf.getVar(ncid,varid))';
  varid = netcdf.inqVarID(ncid,'skt');
  skt_ERAINTERIM=SF_skt*(netcdf.getVar(ncid,varid))+offset_skt;
   netcdf.close(ncid);
  for i=1:length(skt_ERAINTERIM(1,1,:))
  skt=skt_ERAINTERIM(:,:,i);
   skt= double(skt);
   skt(skt==0)= NaN;
   skt=flipud(rot90(skt));
%skt_ERA5=KA_variable_necdtf(ncid,SF_skt,offset_skt,name);
 mask=load('Mask_Coast_LR.mat');
 mask=mask.mask_coast_LR;
 
 pos1=22-12:22+12;
 pos2=31-18:31+17;
 mask_skt=mask(pos1,pos2);
 
 %skt_01= interp2(lon_ERA5,lat_ERA5,skt_01,Long,Lat,'linear');
 mask_skt(mask_skt~=1)=0;
 skt=skt.*mask_skt;
  skt(skt==0)= NaN;
  dia_str=num2str(i);
 name_save= ['ERAINTERIM_skt - ','2015-01-', dia_str];
 save(name_save,'skt','lat_ERAINTERIM','lon_ERAINTERIM')
  end
  
% SM_B= interp2(Long,Lat,SM_b,lon_ERA5,lat_ERA5,'linear');

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