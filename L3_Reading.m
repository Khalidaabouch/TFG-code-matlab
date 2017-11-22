function [l2sm]= L3_Reading(name_SM, Nx, Ny)

ncid = netcdf.open(name_SM,'NC_NOWRITE');
varid = netcdf.inqVarID(ncid,'SM');
varid_dqx = netcdf.inqVarID(ncid,'SM_DQX');
l2sm = netcdf.getVar(ncid,varid);
l2sm_dqx = netcdf.getVar(ncid,varid_dqx);
varid = netcdf.inqVarID(ncid,'lat');
lat_smos = flipud(netcdf.getVar(ncid,varid));
varid = netcdf.inqVarID(ncid,'lon');
lon_smos = netcdf.getVar(ncid,varid);

l2sm = double(flipud(reshape(l2sm,Nx,Ny)'));  
l2sm_dqx = double(flipud(reshape(l2sm_dqx,Nx,Ny)'));
% A= find(l2sm_dqx > 0.07);
l2sm(l2sm_dqx > 0.07) = NaN;
l2sm(l2sm == -999)=NaN;

netcdf.close(ncid);
clearvars -except l2sm lon_smos lat_smos