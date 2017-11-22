function [SM,lat,lon] = KA_load_mat(data)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
A=load(data.name);
SM=A.SM;
lat=A.lat;
lon=A.lon;
end

