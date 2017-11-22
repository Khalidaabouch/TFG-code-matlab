function V = KA_variable_necdtf(ncid,SF,offset,name)
% this function return the our variable after to apply the scale factor and offset
 varid = netcdf.inqVarID(ncid,name);
  V=SF*netcdf.getVar(ncid,varid)+ offset;
   V= double(V);
   V(V==0)= NaN;

end

