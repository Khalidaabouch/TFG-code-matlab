%hola

  h=figure(1);
imagesc(lon_ERA,lat_ERA,skt,'AlphaData',~isnan(skt),'AlphaDataMapping','none')
axis xy; axis equal, colorbar, caxis([270,300]);
colordata = colormap(jet);
colormap(colordata);
%colormap(flipud(colormap));
xlabel('LON');
ylabel('LAT'); 
title('Skt - temperature of ERAINTERIM');