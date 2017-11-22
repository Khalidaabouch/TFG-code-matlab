function SH=KA_mean_month(data)



for i=1:length(data)
% data= ['SM HR - 2015-01-',dia,' - A.mat'];
data1=load(data(i,1).name);
SM_HR(:,:,i)=data1.sm_HR;
end

lon=data1.lon_aux;
lat=data1.lat_aux;
for j=1:length(lon)
    for k=1:length(lat)
        SH(k,j)=nanmean(SM_HR(k,j,:));
    end
end  

h=figure(1)
imagesc(lon,lat, SH,'AlphaData',~isnan(SH),'AlphaDataMapping','none')
axis xy; axis equal, colorbar, caxis([0,0.3]);
colordata = colormap(jet);
colormap(colordata);
colormap(flipud(colormap));
xlabel('LON');
ylabel('LAT'); 

title('SM HR - Adaptive Window Method');
end

