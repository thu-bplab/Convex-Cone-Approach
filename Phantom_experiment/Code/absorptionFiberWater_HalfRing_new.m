function water_absorp = absorptionFiberWater_HalfRing_new(xc, yc, spectrum_H2O)
        %用以校正半环阵中线阵光源到CuSO4管子的距离, new_HalfRing_without_water   
     
        yd = 5.5 + 1.643;
        zd = 2.847; %线阵光源的坐标，单位cm

        L = sqrt( ( yd - yc * 1e2).^2  + zd^2 );
        water_absorp = exp(-L' * spectrum_H2O);
   
       
end