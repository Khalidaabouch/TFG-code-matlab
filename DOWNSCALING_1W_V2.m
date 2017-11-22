function DOWNSCALING_1W(name_SM, dir_name_TB,name_NDVI, name_save, TBV_angles, TBH_angles, ASC_DES,ruta_ERA,l)

% modificado por khalid en 06/11/2015 
% los datos de LST corresponden a ERA5 y ERAINTERIM


tamano_square_window= 5;
numero_pix= 11;
downscaling_factor= 25;
tol = 1e-4;
porosity   = 0.6; 
wilt_point = 0.0005; 

% filename= 'Europe_Coastline_WGS84.shp';
% S = shaperead(filename);
% Lin_Coast_LAT= S.Y;
% Lin_Coast_LON= S.X;
% % name_picture= name_save(9:end);

ncid = netcdf.open(dir_name_TB(1).name,'NC_NOWRITE'); % leer variable de temperatura 
% Get latitude
varid = netcdf.inqVarID(ncid,'lat');
lat_smos = flipud(netcdf.getVar(ncid,varid));
% Get longitude
varid = netcdf.inqVarID(ncid,'lon');
lon_smos = netcdf.getVar(ncid,varid)';
Nx = length(lon_smos); Ny = length(lat_smos);

% Malla a 1 km
deltaLR_lon = lon_smos(2)-lon_smos(1);    % los datos SMOS esgtan a baja resolución (25 km) para pasarlos
deltaLR_lat = lat_smos(1)-lat_smos(2);    % baja resolucion multiplicamos la malla actual por 25
nxr = Nx*downscaling_factor;    %44*25
nyr = Ny*downscaling_factor;    %62*25
lon_aux = linspace(min(lon_smos)-deltaLR_lon/2,max(lon_smos)+deltaLR_lon/2,nxr);   %delta_lon = 0.012Âº -> 1.0220 km
lat_aux = fliplr(linspace(min(lat_smos)-deltaLR_lat/2,max(lat_smos)+deltaLR_lat/2,nyr))'; %delta_lat= 0.009Âº -> 1.0006 km
save('coords','lat_aux','lon_aux','lon_smos','lat_smos')

%LST 
%[LST]= LST_Reading_MODIS(name_LST,lat_aux,lon_aux); %Leemos los datos de temperatura superficial pasandole lat y long en HR
% LST de ERA5/ ERINTERIM
[LST]=LST_Reading_ERA(lat_aux,lon_aux,ruta_ERA,l);


%NDVI
[NDVI]= NDVI_Reading(name_NDVI,lat_aux,lon_aux);

% Bounding coordinates
x1 =  min(lon_aux); x2 = max(lon_aux); y1 = max(lat_aux); y2 = min(lat_aux);

% SMOS L2 SM 
[l2sm]= L3_Reading(name_SM, Nx, Ny);

% Calculate distance to the coast -> mask sea pixels at LR
% -------------------------------------------------------------
load earthmap
lon_etopo5 = earthmap.lon;
lat_etopo5 = earthmap.lat;
coast      = earthmap.map;
coast(coast == 255) = 1; %sea
coast(coast == 230) = 0; %land

lat_coast = lat_etopo5(lat_etopo5 >= y2 & lat_etopo5 <= y1);
lon_coast = lon_etopo5(lon_etopo5 >= x1 & lon_etopo5 <= x2);
ok_coast  = coast(lat_etopo5 >= y2 & lat_etopo5 <= y1, lon_etopo5 >= x1 & lon_etopo5 <= x2);

coast_aux = interp2(lon_coast,lat_coast,double(ok_coast),lon_smos,lat_smos,'linear');
dist_coast = bwdist(coast_aux);
mask_coast_LR= dist_coast;

%Me meto dos píxeles hacia dentro del mar
mask_coast_LR(mask_coast_LR>=1)=1;
mask_coast_LR= bwdist(mask_coast_LR);
mask_coast_LR(mask_coast_LR<=2)=1;
mask_coast_LR(mask_coast_LR>1)=NaN;
save('Mask_Coast_LR.mat','mask_coast_LR');

coast_aux_HR = interp2(lon_coast,lat_coast,double(ok_coast),lon_aux,lat_aux,'linear');

% SMOS L2 SM (ENHANCED)
[l2sm]= L3_Enhanced(l2sm, Ny, Nx, TBH_angles, TBV_angles, 5, 10, tol);

C = find(TBV_angles(:)>290);
RFI = zeros(size(TBV_angles));
RFI(C) = 1;

% 2) TBH_angles
Torig = TBH_angles;
Taux = TBH_angles;
%Taux(mask_inland)  = NaN;
% mask RFI 
Taux(bwdist(RFI)<=1) = NaN;
% Apply EBI
TBH_angles=fillnans(Taux);
TBH_angles(isnan(Torig)) = NaN;

% 3) TBV_angles
Torig = TBV_angles;
Taux = TBV_angles;
%Taux(mask_inland)  = NaN;
% mask RFI 
Taux(bwdist(RFI)<=1) = NaN;
% Apply EBI
TBV_angles=fillnans(Taux);
TBV_angles(isnan(Torig)) = NaN;
clear coast_aux Taux Torig RFI %mask_inland

% Pasamos las TB a 1km y la LST/NDVI a 25km
NDVI_t_40km     = interp2(lon_aux,lat_aux,NDVI,lon_smos,lat_smos,'linear');
LST_t_40km      = interp2(lon_aux,lat_aux,LST,lon_smos,lat_smos,'linear');
TBH_angles_res  = interp2(lon_smos,lat_smos,TBH_angles,lon_aux,lat_aux,'linear');
TBV_angles_res  = interp2(lon_smos,lat_smos,TBV_angles,lon_aux,lat_aux,'linear');

% Preparamos las variables
a_param_prov= NaN(Ny, Nx, 5);
a_param= NaN(Ny, Nx, 5);
mask_LR        = NaN(Ny,Nx);
mask_LR_prov   = NaN(Ny,Nx);
numero_muestras= NaN(Ny, Nx);
LST_norm_HR= NaN(nyr,nxr);
NDVI_norm_HR= NaN(nyr,nxr);
TBH_angles_norm_HR= NaN(nyr,nxr);
TBV_angles_norm_HR= NaN(nyr,nxr);

%Cálculamos la máscara con todos los datos: LST, NDVI y TB's (en LR)
mask_TB_LR = ~isnan(TBH_angles) & ~isnan(TBV_angles);
mask_LR_prov( ~isnan(LST_t_40km) & ~isnan(NDVI_t_40km) & mask_TB_LR)   = 1; 
% mask_IBE_LR= l2sm;
% mask_IBE_LR(~isnan(mask_IBE_LR))=1; 
% mask_IBE_LR= mask_LR_prov.*mask_IBE_LR;
mask_IBE_LR= NaN(Ny,Nx);
mask_IBE_LR(~isnan(l2sm) & ~isnan(mask_LR_prov))= 1;

% Nos quedamos con los datos de NDVI,LST y TB's que usaremos para calcular
% los coeficientes (LR)
NDVI_disp_40km= mask_IBE_LR.*NDVI_t_40km;
LST_disp_40km= mask_IBE_LR.*LST_t_40km;
TBH_disp_40km= mask_IBE_LR.*TBH_angles;
TBV_disp_40km= mask_IBE_LR.*TBV_angles;


%Cálculamos la máscara con todos los datos: LST, NDVI y TB's (en HR)
mask_IBE_res       = NaN(nyr,nxr);
mask_TB_HR = ~isnan(TBH_angles_res) & ~isnan(TBV_angles_res);% & coast_aux_HR < 1;
mask_IBE_res(~isnan(LST) & ~isnan(NDVI) & mask_TB_HR)   = 1;

NDVI_disp= mask_IBE_res.*NDVI;
LST_disp= mask_IBE_res.*LST;
TBH_disp= mask_IBE_res.*TBH_angles_res;
TBV_disp= mask_IBE_res.*TBV_angles_res;

LST_norm_HR= (LST_disp - min(LST_disp(:)))./(max(LST_disp(:)) - min(LST_disp(:)));
NDVI_norm_HR= (NDVI_disp - min(NDVI_disp(:)))./(max(NDVI_disp(:)) - min(NDVI_disp(:)));   
TBH_angles_norm_HR= (TBH_disp - min(TBH_disp(:)))./(max(TBH_disp(:)) - min(TBH_disp(:)));   
TBV_angles_norm_HR= (TBV_disp - min(TBV_disp(:)))./(max(TBV_disp(:)) - min(TBV_disp(:)));


% Coeficientes
for i_lat=1:Ny
    for i_lon=1:Nx
        
        [mask_LR, ventana_NO_adap, ventana_cuadrada]= ventana_adaptativa_AllParam(i_lat,i_lon,mask_IBE_LR, tamano_square_window, numero_pix, Ny, Nx);
        pixeles_disp= sum(sum(~isnan(mask_LR)));
        if pixeles_disp >= 5
            
            numero_muestras(i_lat, i_lon)= pixeles_disp;        
            
            LST_t_40km_prov  = LST_t_40km.*mask_LR;
            NDVI_t_40km_prov  = NDVI_t_40km.*mask_LR;
            TBH_angles_40km_prov  = TBH_angles.*mask_LR;
            TBV_angles_40km_prov  = TBV_angles.*mask_LR;               
            
            LST_norm_LR= (LST_t_40km_prov - min(LST_disp(:)))./(max(LST_disp(:)) - min(LST_disp(:)));
            NDVI_norm_LR= (NDVI_t_40km_prov - min(NDVI_disp(:)))./(max(NDVI_disp(:)) - min(NDVI_disp(:)));
            TBH_angles_norm_LR= (TBH_angles_40km_prov - min(TBH_disp(:)))./(max(TBH_disp(:)) - min(TBH_disp(:)));
            TBV_angles_norm_LR= (TBV_angles_40km_prov - min(TBV_disp(:)))./(max(TBV_disp(:)) - min(TBV_disp(:))); 
            
            LST_LR= reshape(LST_norm_LR,Nx*Ny,1);
            NDVI_LR= reshape(NDVI_norm_LR,Nx*Ny,1);
            TBH_angles_LR   = reshape(TBH_angles_norm_LR,Nx*Ny,1);
            TBV_angles_LR   = reshape(TBV_angles_norm_LR,Nx*Ny,1);           
            mask_LR_vect = reshape(mask_LR,Nx*Ny,1);
            sm_LR_vect   = reshape(l2sm,Nx*Ny,1).*mask_LR_vect;

            M2 = [ones(Ny*Nx,1).*mask_LR_vect LST_LR NDVI_LR TBH_angles_LR TBV_angles_LR];
            M2(isnan(M2))=0;
            sm_LR_vect(isnan(sm_LR_vect))=0;

            [a2,sa2,chisq2,norm_covmat2] = leastSqCoeff(M2,sm_LR_vect,tol);  
            a_param(i_lat, i_lon, :)= a2;        

            clearvars mask_LR LST_t_40km_prov NDVI_t_40km_prov TB_t_40km_prov TBH_angles_40km_prov TBV_angles_40km_prov ...
            NDVI_LR LST_LR TB_LR TBH_angles_LR TBV_angles_LR mask_LR_vect sm_LR_vect ...
            M2 a2 sa2 chisq2 norm_covmat2                     
        
         end   
    end
end

% Interpolamos los coef a la malla de 1km
COEF(:,:,1)  = interp2(lon_smos,lat_smos,a_param(:,:,1),lon_aux,lat_aux,'linear');
COEF(:,:,2)  = interp2(lon_smos,lat_smos,a_param(:,:,2),lon_aux,lat_aux,'linear');
COEF(:,:,3)  = interp2(lon_smos,lat_smos,a_param(:,:,3),lon_aux,lat_aux,'linear');
COEF(:,:,4)  = interp2(lon_smos,lat_smos,a_param(:,:,4),lon_aux,lat_aux,'linear');
COEF(:,:,5)  = interp2(lon_smos,lat_smos,a_param(:,:,5),lon_aux,lat_aux,'linear');

% Buscamos la SM HR
sm_HR= COEF(:,:,1)+COEF(:,:,2).*LST_norm_HR+COEF(:,:,3).*NDVI_norm_HR+COEF(:,:,4).*TBH_angles_norm_HR+COEF(:,:,5).*TBV_angles_norm_HR;

sm_HR(sm_HR < wilt_point) = wilt_point;
sm_HR(sm_HR > porosity  ) = porosity;

% h=figure(1);
% imagesc(lon_aux,lat_aux, sm_HR,'AlphaData',~isnan(sm_HR),'AlphaDataMapping','none')
% axis xy; axis equal, colorbar, caxis([0,0.3]);
% colordata = colormap(jet);
% colormap(colordata);
% colormap(flipud(colormap));
% xlabel('LON');
% ylabel('LAT'); 
% title('SM HR - Adaptive Window Method');

name_save_file= [name_save,' - ',ASC_DES];
save(name_save_file,'sm_HR','lat_aux','lon_aux')

