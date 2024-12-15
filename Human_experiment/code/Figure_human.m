load("Human_experiment\Results\Results_human.mat");
%%
%----------------------------------------------------------------------------------------------------------------%
%
%Show the fitting of the blood vessels
%
%----------------------------------------------------------------------------------------------------------------%
index               = find( ( spectrum_index_diff == 1 ) | ( spectrum_index_diff == 5 )  );
SO2_beyas_artery = SO2_beyas_array_diff( index );
SO2_linear_unmixing_artery =  SO2_linear_unmixing_diff( index );

figure
plot(SO2_beyas_artery,'-*');
hold on
plot(SO2_linear_unmixing_artery,'-*');

figure
for i = 1 : length(SO2_beyas_artery)
    
    subplot(4,4,i)
    plot( spectrum_mean_array_diff(index(i), :)/norm(spectrum_mean_array_diff(index(i), :)) );
    hold on
    plot( squeeze( Spectrum_nearest_diff( :, round(SO2_beyas_artery(i)*201), index(i) ) )/...
          norm( squeeze( Spectrum_nearest_diff( :, round(SO2_beyas_artery(i)*201), index(i) ) ) ) );

end


index                    = find( ( spectrum_index_diff == 2 ) | ( spectrum_index_diff == 6 ) );
SO2_beyas_vein           = SO2_beyas_array_diff( index );
SO2_linear_unmixing_vein = SO2_linear_unmixing_diff( index );

figure
plot(SO2_beyas_vein,'-*');
hold on
plot(SO2_linear_unmixing_vein,'-*');

figure
for i = 1 : length(SO2_beyas_vein)
    
    subplot(5,5,i)
    plot( spectrum_mean_array_diff(index(i), :)/norm(spectrum_mean_array_diff(index(i), :)) );
    hold on
    plot( squeeze( Spectrum_nearest_diff( :, round(SO2_beyas_vein(i)*201), index(i) ) )/...
          norm( squeeze( Spectrum_nearest_diff( :, round(SO2_beyas_vein(i)*201), index(i) ) ) ) );

end

index                      = find( ( spectrum_index_diff == 3 ) | ( spectrum_index_diff == 7 ) );
SO2_beyas_vessel           = SO2_beyas_array_diff( index );
SO2_linear_unmixing_vessel =  SO2_linear_unmixing_diff( index );

figure
plot(SO2_beyas_vessel,'-*');
hold on
plot(SO2_linear_unmixing_vessel,'-*');

figure
for i = 1 : length(SO2_beyas_vein)
    
    subplot(5,5,i)
    plot( spectrum_mean_array_diff(index(i), :)/norm(spectrum_mean_array_diff(index(i), :)) );
    hold on
    plot( squeeze( Spectrum_nearest_diff( :, round(SO2_beyas_vessel(i)*201), index(i) ) )/...
          norm( squeeze( Spectrum_nearest_diff( :, round(SO2_beyas_vessel(i)*201), index(i) ) ) ) );

end


