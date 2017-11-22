function [LST]= LST_Reading_MODIS(name_LST,lat_aux,lon_aux)

% LST
LST_SEL = []; lat_LST = []; lon_LST = [];
ncid = netcdf.open(name_LST,'NC_NOWRITE');
% Get longitude
varid = netcdf.inqVarID(ncid,'longitude');
lon_LST(1,:) = netcdf.getVar(ncid,varid)';
% Get longitude
varid = netcdf.inqVarID(ncid,'latitude');
lat_LST(:,1) = netcdf.getVar(ncid,varid)';
%Get LST Data
varid = netcdf.inqVarID(ncid,'LST_SEL');
LST_SEL = netcdf.getVar(ncid,varid);
LST_SEL= flipud(rot90(LST_SEL));
netcdf.close(ncid); 
LST_SEL(LST_SEL<2)= NaN;
LST = interp2(lon_LST,lat_LST,LST_SEL,lon_aux,lat_aux,'linear');
clearvars -except LST


