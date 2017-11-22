function [LST] =LST_Reading_ERA(lat_aux,lon_aux,ruta,l)
%  los datos de LST de proporcionados por ERA5 estan en una resolución de 30km y los de ERaInterim están a 40km 
% en esta funcion pasamos el dato de entrara a una malla de 1km 
ruta;

data= dir([ruta,'\ERA*']);
data1=load(data(l,1).name);
LST_ERA=data1.skt;
% lon_ERA=data1.lon_ERAINTERIM;
% lat_ERA=data1.lat_ERAINTERIM;
 lon_ERA=data1.lon_ERA;
 lat_ERA=data1.lat_ERA;
LST_ERA(LST_ERA<2)= NaN;

% h=figure(1);
% imagesc(lon_ERA,lat_ERA, LST_ERA,'AlphaData',~isnan(LST_ERA),'AlphaDataMapping','none')
% axis xy; axis equal, colorbar, caxis([270,300]);
% colordata = colormap(jet);
% colormap(colordata);
% colormap(flipud(colormap));
% xlabel('LON');
% ylabel('LAT'); 
% title('skt -ERAINTERIM');


% pasamos skt  de 30Km a 1km en caso de ERA5
% pasamos skt  de 83km a 1km en caso de ERAINTERIM

LST = interp2(lon_ERA,lat_ERA,LST_ERA,lon_aux,lat_aux,'linear');


% h=figure(2);
% imagesc(lon_aux,lat_aux, LST,'AlphaData',~isnan(LST),'AlphaDataMapping','none')
% axis xy; axis equal, colorbar, caxis([270,300]);
% colordata = colormap(jet);
% colormap(colordata);
% colormap(flipud(colormap));
% xlabel('LON');
% ylabel('LAT'); 
% title('skt -ERAINTERIM');

clearvars -except LST
end

