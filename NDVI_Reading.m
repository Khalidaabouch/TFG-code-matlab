function [NDVI]= NDVI_Reading(name_NDVI,lat_aux,lon_aux)

%NDVI
NDVI_SEL = []; lat_NDVI = []; lon_NDVI = [];
ncid = netcdf.open(name_NDVI,'NC_NOWRITE');
% Get longitude
varid = netcdf.inqVarID(ncid,'longitude'); % ¿ como sabemos que el archivo lleva datos de longutud o latitude
lon_NDVI(1,:) = netcdf.getVar(ncid,varid)';
% Get longitude
varid = netcdf.inqVarID(ncid,'latitude');
lat_NDVI(:,1) = netcdf.getVar(ncid,varid)';
% Get NDVI Data
varid = netcdf.inqVarID(ncid,'NDVI_SEL');
NDVI_SEL = netcdf.getVar(ncid,varid);
NDVI_SEL= flipud(rot90(NDVI_SEL));
netcdf.close(ncid);   
NDVI_SEL(NDVI_SEL<0)=NaN;   
NDVI = interp2(lon_NDVI,lat_NDVI,NDVI_SEL,lon_aux,lat_aux,'linear');
clearvars -except NDVI


