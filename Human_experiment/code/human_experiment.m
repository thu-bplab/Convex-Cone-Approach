%% 
clear all
%add the toolbox path
addpath('Toolbox')
%Load Colorbase
load( ['Human_experiment\MC_light_model\ColorBase_s\ColorBase_s.mat' ] );
load( ['Substance_spectra\spectrum_Hb_Cope.mat' ] );
load( ['Substance_spectra\spectrum_HbO2_Cope.mat' ] );
load( ['Substance_spectra\spectrum_H2O.mat' ] );

figure
show_index = round( randperm( size( ColorBase_s, 1 ),7000 ) );
plot( 700 : 10 : 900, ColorBase_s( show_index, : )'./sum( ColorBase_s( show_index, : )',1 ),'Color',[0.6,0.6,0.6] );

%Load PA spectrum
num = 0;
%-------------------------------------------------------------------------%
%Radial - Half Ring Array - With Water Compensation
%-------------------------------------------------------------------------%
wavelengths = 700 : 10 : 900;
water_length = 8.5;
water_compen = exp( water_length * spectrum_H2O );
figure
dirall_experiment = dir( ['Human_experiment\Data\PAspectra_withdraw' '\' 'artery' '\*mat' ] );
for l = 1 : length({dirall_experiment.name})
    
    subplot(1,3,1);
    num = num + 1
    load( ['Human_experiment\Data\PAspectra_withdraw' '\' 'artery' '\' dirall_experiment( l ).name ] );
    Image_array_800_diff{ num }       = Image_800;
    Mask_array_diff     { num }       = Mask;
    spectrum_mean_array_diff(num, :)  = spectrum_mean .* water_compen;
    spectrum_std_array_diff (num, :)  = spectrum_std  .* water_compen;
    
    spectrum_index_diff      (num) = 1;
    X_array_diff             (num) = X;
    Y_array_diff             (num) = Y;
    
    start_ex_array ( num ) = start_ex;
    name_array{ num }           = dirall_experiment( l ).name;
    
    plot(wavelengths, spectrum_mean_array_diff(num, :)/norm(spectrum_mean_array_diff(num, :)),'--','Linewidth',1 );
    hold on
    ylim([0,0.3]);
    
end

dirall_experiment = dir( ['Human_experiment\Data\PAspectra_withdraw' '\' 'vein' '\*mat' ] );
for l = 1 : length({dirall_experiment.name})
    
    subplot(1,3,2);
    num = num + 1
    load( ['Human_experiment\Data\PAspectra_withdraw' '\' 'vein' '\' dirall_experiment( l ).name ] );
    Image_array_800_diff{ num }       = Image_800;
    Mask_array_diff     { num }       = Mask;
    spectrum_mean_array_diff(num, :)  = spectrum_mean .* water_compen;
    spectrum_std_array_diff (num, :)  = spectrum_std  .* water_compen;
    
    spectrum_index_diff      (num) = 2;
    X_array_diff             (num) = X;
    Y_array_diff             (num) = Y;
    
    start_ex_array ( num ) = start_ex;
    name_array{ num }           = dirall_experiment( l ).name;
    
    plot(wavelengths, spectrum_mean_array_diff(num, :)/norm(spectrum_mean_array_diff(num, :)),'--','Linewidth',1 );
    hold on
    ylim([0,0.3]);
    
end

dirall_experiment = dir( ['Human_experiment\Data\PAspectra_withdraw' '\' 'other_vessel' '\*mat' ] );
for l = 1 : length({dirall_experiment.name})
   
    subplot(1,3,3);
    num = num + 1
    load( ['Human_experiment\Data\PAspectra_withdraw' '\' 'other_vessel' '\' dirall_experiment( l ).name ] );
    Image_array_800_diff{ num }       = Image_800;
    Mask_array_diff     { num }       = Mask;
    
    spectrum_mean_array_diff(num, :)  = spectrum_mean .* water_compen;
    spectrum_std_array_diff (num, :)  = spectrum_std  .* water_compen;
    
    spectrum_index_diff      (num) = 3;
    X_array_diff             (num) = X;
    Y_array_diff             (num) = Y;
    
    start_ex_array ( num ) = start_ex;
    name_array{ num }           = dirall_experiment( l ).name;
    
    plot(wavelengths, spectrum_mean_array_diff(num, :)/norm(spectrum_mean_array_diff(num, :)),'--','Linewidth',1 );
    hold on
    ylim([0,0.3]);
    
end

%-------------------------------------------------------------------------%
%Puncture - Half Ring Array - With Water Compensation
%-------------------------------------------------------------------------%
wavelengths = 700 : 10 : 900;
water_length = 8.5;
water_compen = exp( water_length * spectrum_H2O );
SO2_gold_experiment = [0.916,0.45,0.678,0.481];

figure

dirall_experiment = dir( ['Human_experiment\Data\PAspectra_withdraw' '\' 'punture' '\*mat' ] );
for l = 1 : length({dirall_experiment.name})
   
    num = num + 1
    load( ['Human_experiment\Data\PAspectra_withdraw' '\' 'punture' '\' dirall_experiment( l ).name ] );
    Image_array_800_diff{ num }       = Image_800;
    Mask_array_diff     { num }       = Mask;
    
    spectrum_mean_array_diff(num, :)  = spectrum_mean .* water_compen;
    spectrum_std_array_diff (num, :)  = spectrum_std  .* water_compen;
    
    spectrum_index_diff      (num) = 4;
    X_array_diff             (num) = X;
    Y_array_diff             (num) = Y;
    
    start_ex_array ( num ) = start_ex;
    name_array{ num }           = dirall_experiment( l ).name;
    
    plot(wavelengths, spectrum_mean_array_diff(num, :)/norm(spectrum_mean_array_diff(num, :)),'--','Linewidth',1 );
    hold on
    ylim([0,0.3]);
    
end

%-------------------------------------------------------------------------%
%Neck/upper arm - Linear Ring Array - No Water Compensation
%-------------------------------------------------------------------------%
wavelengths = 700 : 10 : 900;
water_length = 0;
water_compen = exp( water_length * spectrum_H2O );

figure

dirall_experiment = dir( ['Human_experiment\Data\PAspectra_withdraw' '\' 'brachial_and_neck_artery' '\*mat' ] );
for l = 1 : length({dirall_experiment.name})
   
    num = num + 1
    load( ['Human_experiment\Data\PAspectra_withdraw' '\' 'brachial_and_neck_artery' '\' dirall_experiment( l ).name ] );
    Image_array_800_diff{ num }       = Image_800;
    Mask_array_diff     { num }       = Mask;
    
    spectrum_mean_array_diff(num, :)  = spectrum_mean .* water_compen;
    spectrum_std_array_diff (num, :)  = spectrum_std  .* water_compen;
    
    spectrum_index_diff      (num) = 5;
    X_array_diff             (num) = X;
    Y_array_diff             (num) = Y;
    
    start_ex_array ( num ) = start_ex;
    name_array{ num }           = dirall_experiment( l ).name;
    
    plot(wavelengths, spectrum_mean_array_diff(num, :)/norm(spectrum_mean_array_diff(num, :)),'--','Linewidth',1 );
    hold on
    ylim([0,0.3]);
    
end

dirall_experiment = dir( ['Human_experiment\Data\PAspectra_withdraw' '\' 'brachial_and_neck_vein' '\*mat' ] );
for l = 1 : length({dirall_experiment.name})
   
    num = num + 1
    load( ['Human_experiment\Data\PAspectra_withdraw' '\' 'brachial_and_neck_vein' '\' dirall_experiment( l ).name ] );
    Image_array_800_diff{ num }       = Image_800;
    Mask_array_diff     { num }       = Mask;
    
    spectrum_mean_array_diff(num, :)  = spectrum_mean .* water_compen;
    spectrum_std_array_diff (num, :)  = spectrum_std  .* water_compen;
    
    spectrum_index_diff      (num) = 6;
    X_array_diff             (num) = X;
    Y_array_diff             (num) = Y;
    
    start_ex_array ( num ) = start_ex;
    name_array{ num }           = dirall_experiment( l ).name;
    
    plot(wavelengths, spectrum_mean_array_diff(num, :)/norm(spectrum_mean_array_diff(num, :)),'--','Linewidth',1 );
    hold on
    ylim([0,0.3]);
    
end

dirall_experiment = dir( ['Human_experiment\Data\PAspectra_withdraw' '\' 'brachial_and_neck_vessel' '\*mat' ] );
for l = 1 : length({dirall_experiment.name})
   
    num = num + 1
    load( ['Human_experiment\Data\PAspectra_withdraw' '\' 'brachial_and_neck_vessel' '\' dirall_experiment( l ).name ] );
    Image_array_800_diff{ num }       = Image_800;
    Mask_array_diff     { num }       = Mask;
    
    spectrum_mean_array_diff(num, :)  = spectrum_mean .* water_compen;
    spectrum_std_array_diff (num, :)  = spectrum_std  .* water_compen;
    
    spectrum_index_diff      (num) = 7;
    X_array_diff             (num) = X;
    Y_array_diff             (num) = Y;
    
    start_ex_array ( num ) = start_ex;
    name_array{ num }           = dirall_experiment( l ).name;
    
    plot(wavelengths, spectrum_mean_array_diff(num, :)/norm(spectrum_mean_array_diff(num, :)),'--','Linewidth',1 );
    hold on
    ylim([0,0.3]);
    
end
%%
%-------------------------------------------------------------------------%
%
%Calculate blood oxygen saturation
%
%-------------------------------------------------------------------------%


clear SO2_convex_cone_array_diff  SO2_beyas_array_diff  SO2_linear_unmixing_diff Angle_array_diff  Spectrum_nearest_diff P_post_array_diff

tic 

for i = 1 : size( spectrum_mean_array_diff, 1 )
    
    i
    [sO2_convex_cone, Angle, Angle_level, spectrum_nearest, ~] = convexConeSO2_noise...
                       ( spectrum_mean_array_diff(i,:), spectrum_Hb, spectrum_HbO2, ColorBase_s, spectrum_std_array_diff (i,:) );    
    
    [SO2_beyas, P_post] = convexConeSO2_bayes( spectrum_mean_array_diff(i,:), Angle, spectrum_std_array_diff (i, :) );
    
    SO2_convex_cone_array_diff( i ) = sO2_convex_cone;
    SO2_beyas_array_diff      ( i ) = SO2_beyas;
    Angle_array_diff(:, i)          = Angle;
    Spectrum_nearest_diff(:, :, i)  = spectrum_nearest;
    P_post_array_diff(i, :)         = P_post;
    
    SO2_linear_unmixing_diff( i ) = linearUnmixing( spectrum_mean_array_diff(i,:), spectrum_HbO2, spectrum_Hb);
    
end

toc
save( ['Human_experiment' '\' 'Results\' 'Results_human.mat'  ] );
