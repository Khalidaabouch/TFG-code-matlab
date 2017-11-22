
% sacamos Sm l3 a 25km
clear
clc
Orbita='A';
Ano_Down='2015';

ruta_L2SM= 'P:\codigo\L2';
addpath(ruta_L2SM)

name_L3= [ruta_L2SM,'\BEC_BIN_SM_',Orbita,'_',Ano_Down,'*'];
listing_L3 = dir(name_L3);
len_L3= length(listing_L3);
i=1;
M=1;
for l=1:len_L3 
    
% mostar los datos de enero 2015
%dia_srt=num2str(l);
    
    name_SM= listing_L3(l,1).name;
    ano_str= listing_L3(l,1).name(14:17);
    mes_str= listing_L3(l,1).name(18:19);
    dia_str= listing_L3(l,1).name(20:21);
    ano_num= str2num(ano_str);
    
   ncid = netcdf.open(name_SM,'NC_NOWRITE');
varid = netcdf.inqVarID(ncid,'SM');
varid_dqx = netcdf.inqVarID(ncid,'SM_DQX');
l2sm = netcdf.getVar(ncid,varid);
l2sm_dqx = netcdf.getVar(ncid,varid_dqx);
varid = netcdf.inqVarID(ncid,'lat');
lat_smos = flipud(netcdf.getVar(ncid,varid));
varid = netcdf.inqVarID(ncid,'lon');
lon_smos = netcdf.getVar(ncid,varid);


Nx = length(lon_smos); Ny = length(lat_smos);
l2sm = double(flipud(reshape(l2sm,Nx,Ny)'));  
l2sm_dqx = double(flipud(reshape(l2sm_dqx,Nx,Ny)'));
% A= find(l2sm_dqx > 0.07);
l2sm(l2sm_dqx > 0.07) = NaN;
l2sm(l2sm == -999)=NaN;
netcdf.close(ncid);

%
save(['SM25km_2015','-',mes_str,'-',dia_str,'.mat'],'l2sm','lon_smos','lat_smos');
    
if (M==str2num(mes_str))
    SM25km(:,:,i)=l2sm;
    i=i+1;
    
else
    for j=1:length(lon_smos)
        for k=1:length(lat_smos)
            SM25km_M(k,j)=nanmean(SM25km(k,j,:));
        end
    end
    save(['SM25km_2015','-',mes_str,'.mat'],'SM25km_M','lon_smos','lat_smos');
    clear SM25km
    M=str2num(mes_str);
     i=1;
     SM25km(:,:,i)=l2sm;
    i=i+1;
end
    
    
end
%%
for j=1:length(lon_smos)
        for k=1:length(lat_smos)
            SM25km_M(k,j)=nanmean(SM25km(k,j,:));
        end
    end
 save(['SM25km_2015','-',mes_str,'.mat'],'SM25km_M','lon_smos','lat_smos');
%%

h=figure(1)
imagesc(lon_smos,lat_smos,SM25km_M,'AlphaData',~isnan(SM25km_M),'AlphaDataMapping','none')
axis xy; axis equal, colorbar, caxis([0,0.3]);
colordata = colormap(jet);
colormap(colordata);
colormap(flipud(colormap));

xlabel('LON');
ylabel('LAT'); 
title(['SM_H - Adaptive Window Method ERA5 Febrero']);


%end



