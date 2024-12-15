function SO2 = linearUnmixing(PA, spectra_HbO2, spectra_Hb)

    C = [spectra_HbO2', spectra_Hb']\PA';
    
    if(C(1) < 0)
        SO2 = 0;
    elseif(C(2) < 0)
        SO2 = 1;
    else
        SO2 = C(1)/sum(C);
    end
end