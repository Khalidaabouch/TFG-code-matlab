clear

filename= 'SM_RE04_MIR_CLF33A_20150301T000000_20150303T235959_300_001_7.hdf';
%  coord= load('coords');
%  lat_aux= coord.lat_aux;
%  lon_aux= coord.lon_aux;
hdr = hdrread('SM_RE04_MIR_CLF33A_20150301T000000_20150303T235959_300_001_7.hdr');
A= hdrinfo(filename);
