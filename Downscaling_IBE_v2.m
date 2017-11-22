
clear all
close all

% addpath('save_fig')

%Iniciales de la zona de estudio (p.e. EUR, BRZ, IBE)
iniciales_zona= 'IBE';
%Orbita Ascendente o Decendente
Orbita= 'A';
%Año para el que se va a hacer el Downscaling
Ano_Down= '2015';

% @Ruta a las carpetas que contienen los L1, L3 y MODIS
ruta_L1C= 'C:\Users\khalid.aabouch\Desktop\ERA&INREIN&MODIS mapa\L1C';

ruta_MOD13A2= 'C:\Users\khalid.aabouch\Desktop\ERA&INREIN&MODIS mapa\MOD13A2';
ruta_ERA= 'C:\Users\khalid.aabouch\Desktop\ERA&INREIN&MODIS mapa\ERAINTERIM_mat_v2';
  % ERA5 33KM
  
%ruta_ERA='C:\Users\khalid.aabouch\Desktop\ERA&INREIN&MODIS mapa\ERAint_MAT';
   %ERAINTERIM 83km
%ruta_ERA='C:\Users\Khalid\Desktop\Matlab_TFG\ERA&INREIN&MODIS mapa\ERAINTERIM_83Km_2015';
%ruta_MYD11A1= 'C:\Users\Khalid\Desktop\Matlab_TFG\ERA&INREIN&MODIS mapa\MYD11A1';

addpath(ruta_L1C)
addpath(ruta_L2SM)
addpath(ruta_ERA)
addpath(ruta_MOD13A2)
%addpath(ruta_MYD11A1)

name_L3= [ruta_L2SM,'\BEC_BIN_SM_',Orbita,'_',Ano_Down,'*'];
listing_L3 = dir(name_L3);
len_L3= length(listing_L3);

for l=1:len_L3 
    
% mostar los datos de enero 2015
%dia_srt=num2str(l);
    tic
    name_SM= listing_L3(l,1).name;
    ano_str= listing_L3(l,1).name(14:17);
    mes_str= listing_L3(l,1).name(18:19);
    dia_str= listing_L3(l,1).name(20:21);
    ano_num= str2num(ano_str);
     % greg_date=datetime([ano_str, '-', mes_str, '-', dia_str]);
     greg_date=datetime([ano_str, '-', mes_str, '-', dia_str]);  
    julian_date= num2str(jl_date(greg_date));
    julian_date_str= julian_date(5:7); 
    julian_date_num= str2num(julian_date_str);    
    
    % Selección de los mapas de TBs correspondientes
    ASC_DES= listing_L3(l,1).name(12);
    if strcmp(ASC_DES,'A')
        % ASCENDING
        dir_name_TB= dir([ruta_L1C,'\TB_SUR_',iniciales_zona,'_',ano_str,mes_str,dia_str,'*T0*']); % No entiendo los parametros de entrada
    else
        % DESCENDING
        dir_name_TB_A= dir([ruta_L1C,'\TB_SUR_',iniciales_zona,'_',ano_str,mes_str,dia_str,'*T1*_*']);
        dir_name_TB_B= dir([ruta_L1C,'\TB_SUR_',iniciales_zona,'_',ano_str,mes_str,dia_str,'*T2*_*']);
        dir_name_TB=[dir_name_TB_A; dir_name_TB_B];
    end
    
    fecha_num_LSTNDVI= jl_date(greg_date);
    fecha_str_LSTNDVI= [ano_str, mes_str, dia_str];
    
    greg_date_LSTNDVI= datetime([fecha_str_LSTNDVI(1:4),'-',fecha_str_LSTNDVI(5:6),'-',fecha_str_LSTNDVI(7:8)]);
    julian_date_LSTNDVI= num2str(jl_date(greg_date_LSTNDVI));
    julian_date_LSTNDVI_str= julian_date_LSTNDVI(5:7);
    julian_date_LSTNDVI_num= str2num(julian_date_LSTNDVI_str); 
    
    % aqui empiezo a modificar el codigo 06/11/2017
    % Selección del mapa de LST correspondiente a ERA5
    %name_LST= ['MYD11A1.A',julian_date_LSTNDVI,'_mosaic_geo_LST.nc']; 

   % name_LST_ERA5=['ERA5_skt -2015-01-',dis_str];
   % [LST]=LST_Reading_ERA(lat_aux,lon_aux,ruta_ERA5,l);
    
    
    % Selección del mapa de NDVI correspondiente
    if 16-mod(julian_date_LSTNDVI_num,16) < mod(julian_date_LSTNDVI_num,16)-1
        NDVI_FN_num= ceil(julian_date_LSTNDVI_num/16)*16+1;
        if NDVI_FN_num > 353
            NDVI_FN= '353';
            name_NDVI= ['MOD13A2.A',num2str(str2num(ano_str)),NDVI_FN,'_mosaic_geo_NDVI.nc'];
        else
            NDVI_FN= sprintf('%03d',NDVI_FN_num);
            name_NDVI= ['MOD13A2.A',ano_str,NDVI_FN,'_mosaic_geo_NDVI.nc'];
        end
    else
        NDVI_FN= sprintf('%03d',floor((julian_date_LSTNDVI_num)/16)*16+1);%Quincena-Fortnight
        name_NDVI= ['MOD13A2.A',ano_str,NDVI_FN,'_mosaic_geo_NDVI.nc'];
    end
    
    %   Me ayuda a saber que dato es el que falta   %
    A= ~isempty(dir_name_TB);                       %   
    AA= exist(name_NDVI);                           %
  %  AAA= exist(name_LST);                           %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Si existen los mapas de TB, LST, NDVI entonces se hace el downscaling
   % if ~isempty(dir_name_TB) && exist(name_NDVI) && exist(name_LST)
        
        len_TB= length(dir_name_TB);
        [TBV_angles, TBH_angles]= TB_reading_V2(len_TB, dir_name_TB);
        
        name_save= ['SM HR - ',ano_str, '-', mes_str, '-', dia_str];
        DOWNSCALING_1W_V2(name_SM, dir_name_TB,name_NDVI, name_save, TBV_angles, TBH_angles, ASC_DES,ruta_ERA,l);
        
        disp(name_SM)
        disp(dir_name_TB(1).name)
        disp(name_NDVI)
      %  disp(name_LST_ERA5)
        disp('------------ OK ------------')
        toc
        
    %end  
    
    clearvars -except name_L3 l listing_L3 len_L3 ruta_L1C ruta_L2SM ruta_MOD13A2 ruta_ERA iniciales_zona
  
end

