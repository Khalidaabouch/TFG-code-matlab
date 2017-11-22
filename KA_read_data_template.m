% KA_read_data_template
clear all

name='Albedo';
ruta='C:\Users\Khalid\Desktop\Matlab_TFG\Simolacion 1\CATDS data';
%name_NRTS=dir([ruta_NRTS,'\NRTSM001D025A_BEC_BIN_SM_A_2017*']');
 name_ERA5=dir([ruta,'\_grib2netcdf-atls00-98f536083ae965b31b0d04811be6f4c6-vlNW0o (1)*']);
addpath(ruta)
info=ncinfo(name_ERA5.name);
SF_Albedo=info.Variables(5).Attributes(1).Value;
offset_Albedo=info.Variables(5).Attributes(2).Value;
ncid = netcdf.open(name_ERA5.name,'NC_NOWRITE');
varid = netcdf.inqVarID(ncid,'Vertical integral of water vapour');
% Albedo_ERA5=KA_variable_necdtf(ncid,SF_Albedo,offset_Albedo,name);