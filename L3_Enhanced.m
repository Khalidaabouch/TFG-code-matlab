function [l2sm]= L3_Enhanced(l2sm, Ny, Nx, TBH_angles, TBV_angles, tamano_square_window, numero_pix, tol)
% clear all
% close all

%New L3 fill
a_param_prov= NaN(Ny, Nx, 3);
a_param= NaN(Ny, Nx, 3);
mask_LR        = NaN(Ny,Nx);
mask_LR_prov   = NaN(Ny,Nx);
mask_LR_prov = ~isnan(TBH_angles) & ~isnan(TBV_angles);
% mask_IBE= l2sm;
% mask_IBE(~isnan(mask_IBE))=1; 
% mask_IBE= mask_LR_prov.*mask_IBE;
l2sm_final= NaN(Ny,Nx,2);
mask_NaNs= NaN(Ny,Nx);

mask_IBE= NaN(Ny,Nx);
mask_IBE(~isnan(l2sm) & mask_LR_prov)= 1;

numero_muestras= NaN(Ny, Nx);

for i_lat=1:Ny
    for i_lon=1:Nx
        
        [mask_LR, ventana_NO_adap, ventana_cuadrada]= ventana_adaptativa_AllParam(i_lat,i_lon,mask_IBE, tamano_square_window, numero_pix, Ny, Nx);
        pixeles_disp= sum(sum(~isnan(mask_LR)));
        if pixeles_disp >= 3
            
            numero_muestras(i_lat, i_lon)= pixeles_disp;        

            TBH_angles_40km_prov  = TBH_angles.*mask_LR;
            TBV_angles_40km_prov  = TBV_angles.*mask_LR;        
            TBH_angles_LR   = reshape(TBH_angles_40km_prov,Nx*Ny,1);
            TBV_angles_LR   = reshape(TBV_angles_40km_prov,Nx*Ny,1);

            mask_LR_vect = reshape(mask_LR,Nx*Ny,1);
            sm_LR_vect   = reshape(l2sm,Nx*Ny,1).*mask_LR_vect;

            M2 = [ones(Ny*Nx,1).*mask_LR_vect TBH_angles_LR TBV_angles_LR];
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

l2sm_new= a_param(:,:,1)+a_param(:,:,2).*TBH_angles+a_param(:,:,3).*TBV_angles;

mask_NaNs(isnan(l2sm))= 1;
l2sm_new(l2sm_new==0)= 999;
l2sm_final(:,:,1)= l2sm_new.*mask_NaNs;

l2sm_NO_zeros= l2sm;
l2sm_NO_zeros(l2sm_NO_zeros==0)= 999;
l2sm_final(:,:,2)= l2sm_NO_zeros;

l2sm= nansum(l2sm_final, 3);
l2sm(l2sm==0)= NaN;
l2sm(l2sm==999)= 0;

clearvars -except l2sm











