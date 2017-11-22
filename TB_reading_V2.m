function [TBV_angles, TBH_angles]= TB_reading(len_TB, dir_name_TB)

    ncid = netcdf.open(dir_name_TB(1).name,'NC_NOWRITE');
    % Get latitude
    varid = netcdf.inqVarID(ncid,'lat');
    lat_smos = flipud(netcdf.getVar(ncid,varid));
    % Get longitude
    varid = netcdf.inqVarID(ncid,'lon');
    lon_smos = netcdf.getVar(ncid,varid)';
    Nx = length(lon_smos); Ny = length(lat_smos);
    netcdf.close(ncid)
    clear ncid varid
    
    Ths_3250_U= NaN(Ny,Nx,len_TB);
    Ths_4250_U= NaN(Ny,Nx,len_TB);
    Ths_5250_U= NaN(Ny,Nx,len_TB);
    Tvs_3250_U= NaN(Ny,Nx,len_TB);
    Tvs_4250_U= NaN(Ny,Nx,len_TB);
    Tvs_5250_U= NaN(Ny,Nx,len_TB);
    
    for i=1:len_TB
        
        name_TB= dir_name_TB(i).name;
        ncid = netcdf.open(name_TB,'NC_NOWRITE');
        
        % Get Th and Tv at 32.5 deg
        varid = netcdf.inqVarID(ncid,'Ths_3250');
        Ths_3250 = netcdf.getVar(ncid,varid);
        Ths_3250 = double(flipud(reshape(Ths_3250,Nx,Ny)'));  % flipud cambia el orden del vector ascendente
        Ths_3250(Ths_3250 < 120)=NaN; % se tescartan las tenperaturas menores de 120K?¿?¿?¿?
        Ths_3250(Ths_3250 == -999)=NaN;
        Ths_3250_U(:,:,i)= Ths_3250;

        varid = netcdf.inqVarID(ncid,'Tvs_3250');
        Tvs_3250 = netcdf.getVar(ncid,varid);
        Tvs_3250 = double(flipud(reshape(Tvs_3250,Nx,Ny)'));
        Tvs_3250(Tvs_3250 < 120)=NaN;
        Tvs_3250(Tvs_3250 == -999)=NaN;
        Tvs_3250_U(:,:,i)= Tvs_3250;

        % Los valores de la temperatura tanto a la polaridad H como la V
        % están a los angulos de incidencia 32.5 , 42.5 y 52.5
        
        
        % Get Th and Tv at 42.5 deg
        varid = netcdf.inqVarID(ncid,'Ths_4250');
        Ths_4250 = netcdf.getVar(ncid,varid);
        Ths_4250 = double(flipud(reshape(Ths_4250,Nx,Ny)'));
        Ths_4250(Ths_4250 < 120)=NaN;
        Ths_4250(Ths_4250 == -999)=NaN;
        Ths_4250_U(:,:,i)= Ths_4250;

        varid = netcdf.inqVarID(ncid,'Tvs_4250');
        Tvs_4250 = netcdf.getVar(ncid,varid);
        Tvs_4250 = double(flipud(reshape(Tvs_4250,Nx,Ny)'));
        Tvs_4250(Tvs_4250 < 120)=NaN;
        Tvs_4250(Tvs_4250 == -999)=NaN;
        Tvs_4250_U(:,:,i)= Tvs_4250;

        % Get Th and Tv at 52.5 deg
        varid = netcdf.inqVarID(ncid,'Ths_5250');
        Ths_5250 = netcdf.getVar(ncid,varid);
        Ths_5250 = double(flipud(reshape(Ths_5250,Nx,Ny)'));
        Ths_5250(Ths_5250 < 120)=NaN;
        Ths_5250(Ths_5250 == -999)=NaN;
        Ths_5250_U(:,:,i)= Ths_5250;

        varid = netcdf.inqVarID(ncid,'Tvs_5250');
        Tvs_5250 = netcdf.getVar(ncid,varid);
        Tvs_5250 = double(flipud(reshape(Tvs_5250,Nx,Ny)'));
        Tvs_5250(Tvs_5250 < 120)=NaN;
        Tvs_5250(Tvs_5250 == -999)=NaN;
        Tvs_5250_U(:,:,i)= Tvs_5250;
        
        netcdf.close(ncid)
        clear Ths_4251 Ths_3250 Ths_5250 Tvs_4250 Tvs_3250 Tvs_5250 ncid varid
                
    end
    
    
    Ths_3250_U(Ths_3250_U==0)= -999;
    Ths_4250_U(Ths_4250_U==0)= -999;
    Ths_5250_U(Ths_5250_U==0)= -999;
    Tvs_3250_U(Tvs_3250_U==0)= -999;
    Tvs_4250_U(Tvs_4250_U==0)= -999;
    Tvs_5250_U(Tvs_5250_U==0)= -999;

    Ths_3250= nansum(Ths_3250_U,3);
    Ths_4250= nansum(Ths_4250_U,3);
    Ths_5250= nansum(Ths_5250_U,3);
    Tvs_3250= nansum(Tvs_3250_U,3);
    Tvs_4250= nansum(Tvs_4250_U,3);
    Tvs_5250= nansum(Tvs_5250_U,3);

    Ths_3250(Ths_3250==0)= NaN;
    Ths_4250(Ths_4250==0)= NaN;
    Ths_5250(Ths_5250==0)= NaN;
    Tvs_3250(Tvs_3250==0)= NaN;
    Tvs_4250(Tvs_4250==0)= NaN;
    Tvs_5250(Tvs_5250==0)= NaN;

    Ths_3250(Ths_3250==-999)= 0;
    Ths_4250(Ths_4250==-999)= 0;
    Ths_5250(Ths_5250==-999)= 0;
    Tvs_3250(Tvs_3250==-999)= 0;
    Tvs_4250(Tvs_4250==-999)= 0;
    Tvs_5250(Tvs_5250==-999)= 0;



    % Calculate TBp_angle = (TBp_325 + TBp_425 + TBp_525)/3
    N_meas = isfinite(Ths_3250) + isfinite(Ths_4250) + isfinite(Ths_5250); % comprueba que la matriz tenga valores reales
    Ths_3250(isnan(Ths_3250)) = 0;
    Ths_4250(isnan(Ths_4250)) = 0;
    Ths_5250(isnan(Ths_5250)) = 0;
    TBH_angles = (Ths_3250 + Ths_4250 + Ths_5250)./N_meas; % Note 0/0=NaN
    TBH_angles(TBH_angles == 0)=NaN;

    N_meas = isfinite(Tvs_3250) + isfinite(Tvs_4250) + isfinite(Tvs_5250);
    Tvs_3250(isnan(Tvs_3250)) = 0;
    Tvs_4250(isnan(Tvs_4250)) = 0;
    Tvs_5250(isnan(Tvs_5250)) = 0;
    TBV_angles = (Tvs_3250 + Tvs_4250 + Tvs_5250)./N_meas; % Note 0/0=NaN
    TBV_angles(TBV_angles == 0)=NaN;
    clearvars -except TBV_angles TBH_angles
    
    
    
    