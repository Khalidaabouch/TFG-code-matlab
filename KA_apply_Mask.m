function [ Mask ] = KA_apply_Mask(lon,lat)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

 x1 =  min(lon); x2 = max(lon); y1 = max(lat); y2 = min(lat);
   
   load earthmap
   
 lon_etopo5 = earthmap.lon;
 lat_etopo5= earthmap.lat;
coast      = earthmap.map;
 coast(coast == 255) = 1; %sea
 coast(coast == 230) = 0; %land
% 
 lat_coast = lat_etopo5(lat_etopo5 >= y2 & lat_etopo5 <= y1);
 lon_coast = lon_etopo5(lon_etopo5 >= x1 & lon_etopo5 <= x2);
 ok_coast  = coast(lat_etopo5 >= y2 & lat_etopo5 <= y1, lon_etopo5 >= x1 & lon_etopo5 <= x2);
 
% ok_coast=flipud(rot90(ok_coast));
 
% 
% coast_aux = interp2(lon_coast,lat_coast,double(ok_coast),lon,lat,'linear');
 coast_aux = interp2(lon_coast,lat_coast,double(ok_coast),lon,lat,'linear');
 
 dist_coast = bwdist(coast_aux);
 Mask= dist_coast;

end

