function [mask_LR_SM, ventana_NO_adap, ventana_cuadrada]= ventana_adaptativa_AllParam(Entrada_LAT,Entrada_LON,mask_AllParam, tamano_ventana, num_pix_ventana, Ny, Nx)

mask= load('Mask_Coast_LR.mat');
mask_coast= mask.mask_coast_LR;

numero_muestras_param_A= NaN(Ny, Nx);
ventana_NO_adap= NaN(Ny, Nx);
ventana_cuadrada= NaN(Ny, Nx);

WW_WH_ventana= tamano_ventana;
WS=floor(WW_WH_ventana/2);%Window size
        
mask_LR_SM= NaN(Ny,Nx);
mask_NO_adap= NaN(Ny,Nx);
i=1;

IN_LON= Entrada_LON-WS;
OUT_LON= Entrada_LON+WS;
IN_LAT= Entrada_LAT-WS;
OUT_LAT= Entrada_LAT+WS;

WW=WW_WH_ventana;%Window width
WH=WW_WH_ventana;%Window height

% Cálculo de la ventana fija y adaptativa
if mask_coast(Entrada_LAT, Entrada_LON)==1

    if IN_LON < 1
        IN_LON= 1;
        WW= WS+Entrada_LON;
    end
    if OUT_LON > Nx
        OUT_LON= Nx;
        WW= (Nx+1)-IN_LON;
    end
    if IN_LAT < 1
        IN_LAT= 1;
        WH= WS+Entrada_LAT;
    end
    if Entrada_LAT+WS > Ny
        OUT_LAT= Ny;
        WH= (Ny+1)-IN_LAT;
    end    

    for COL= IN_LON:OUT_LON;
        for FIL= IN_LAT:OUT_LAT;                    
            d_prob(i,1)= sqrt((COL-Entrada_LON)^2 + (FIL-Entrada_LAT)^2);
            LON_s(i)= COL;
            LAT_s(i)= FIL;        
            i= i+1;
        end    
    end

    SubWindow_mask= mask_AllParam(IN_LAT:OUT_LAT, IN_LON:OUT_LON);
    M= reshape(SubWindow_mask, 1, WW*WH);
    nan_pos= find(isnan(M));
    M(nan_pos)=[];
    LAT_s(nan_pos)= [];
    LON_s(nan_pos)= [];
    d_prob(nan_pos)=[];
    [Ds,I] = sort(d_prob);
    LAT_s= LAT_s(I);
    LON_s= LON_s(I);

    len_pix= length(LON_s);
    if len_pix<num_pix_ventana
%         numero_muestras_param_A(Entrada_LAT, Entrada_LON)= len_pix;
        LAT_s= LAT_s(1:len_pix);
        LON_s= LON_s(1:len_pix);
        for i=1:len_pix;
            mask_LR_SM(LAT_s(i), LON_s(i))= mask_AllParam(LAT_s(i), LON_s(i));
        end

    else len_pix >= num_pix_ventana; 
%         numero_muestras_param_A(Entrada_LAT, Entrada_LON)= num_pix_ventana;
        LAT_s= LAT_s(1:num_pix_ventana);
        LON_s= LON_s(1:num_pix_ventana);

        for i=1:num_pix_ventana;
            mask_LR_SM(LAT_s(i), LON_s(i))= mask_AllParam(LAT_s(i), LON_s(i));
        end
    end

    mask_NO_adap(IN_LAT:OUT_LAT, IN_LON:OUT_LON)=1;
    ventana_NO_adap(:,:)= mask_NO_adap.*mask_coast;
    ventana_cuadrada(:,:)= mask_NO_adap;

    clearvars -except mask_LR_SM ventana_NO_adap ventana_cuadrada 
end        


















