
clear all
clc
addpath('Toolbox');
%load absroption spectrum
load( ['Substance_spectra\spectrumCuSO4_extin.mat' ] );
load( ['Substance_spectra\spectrumNiSO4_extin.mat' ] );
load( ['Substance_spectra\spectrum_H2O.mat' ] );

spectrum_Hb   = spectrum_extin_CuSO4;
spectrum_HbO2 = spectrum_extin_NiSO4 * 12.7;
wavelengths   = 700 : 10 : 900;

figure
plot(wavelengths,spectrum_Hb/norm(spectrum_Hb));
hold on
plot(wavelengths,spectrum_HbO2/norm(spectrum_HbO2));
hold on
plot(wavelengths,spectrum_H2O/norm(spectrum_H2O));


%Linear-unmixing get real sO2
SO2_gold    = zeros(1,5);
SO2_gold(1) = 0; 
SO2_gold(5) = 1; 

load(['Phantom_experiment' '\' 'Data' '\' 'Tube_linear_unmixing' '\' 'standard_image_25_75.mat'] );
correct = spectrum_extin_CuSO4./mean(spectrum_norm);
load(['Phantom_experiment' '\' 'Data' '\' 'Tube_linear_unmixing' '\' 'Cu_Ni_25_image.mat'] );
spectrum_25 = correct.*mean(spectrum_norm(1:7,:));%
SO2_tube_linear = linearUnmixing(spectrum_25, spectrum_HbO2, spectrum_Hb);
SO2_gold(2) = SO2_tube_linear;

figure
plot(700 : 10 : 900,spectrum_25/norm(spectrum_25),'LineWidth',2);
hold on
plot(700 : 10 : 900, ((1-SO2_tube_linear)*spectrum_Hb + SO2_tube_linear * spectrum_HbO2)/norm(((1-SO2_tube_linear)*spectrum_Hb + SO2_tube_linear* spectrum_HbO2)),'LineWidth',2);
legend('PA_spectra',['Linear_Unmixing' num2str(SO2_tube_linear) ]);

% Only the tubes were imaged(without phantom) and the true value of the sNi was calculated by linear unmixing
load(['Phantom_experiment' '\' 'Data' '\' 'Tube_linear_unmixing' '\' 'standard_image_50.mat'] );
correct = spectrum_extin_CuSO4./mean(spectrum_norm);
load(['Phantom_experiment' '\' 'Data' '\' 'Tube_linear_unmixing' '\' 'Cu_Ni_50_image.mat'] );
spectrum_50 = correct.*mean(spectrum_norm);
SO2_tube_linear = linearUnmixing(spectrum_50, spectrum_HbO2, spectrum_Hb);
SO2_gold(3) = SO2_tube_linear;

figure
plot(700 : 10 : 900,spectrum_50/norm(spectrum_50),'LineWidth',2);
hold on
plot(700 : 10 : 900,((1-SO2_tube_linear)*spectrum_Hb + SO2_tube_linear * spectrum_HbO2)/norm(((1-SO2_tube_linear)*spectrum_Hb + SO2_tube_linear * spectrum_HbO2)),'LineWidth',2);
legend('PA_spectra',['Linear_Unmixing' num2str(SO2_tube_linear) ]);


load(['Phantom_experiment' '\' 'Data' '\' 'Tube_linear_unmixing' '\' 'standard_image_25_75.mat'] );
correct = spectrum_extin_CuSO4./mean(spectrum_norm);
load(['Phantom_experiment' '\' 'Data' '\' 'Tube_linear_unmixing' '\' 'Cu_Ni_75_image.mat'] );
spectrum_75 = correct.*mean(spectrum_norm);
SO2_tube_linear = linearUnmixing(spectrum_75, spectrum_HbO2, spectrum_Hb);
SO2_gold(4) = SO2_tube_linear;

figure
plot(700 : 10 : 900,spectrum_75/norm(spectrum_75),'LineWidth',2);
hold on
plot(700 : 10 : 900,((1-SO2_tube_linear)*spectrum_Hb + SO2_tube_linear * spectrum_HbO2)/norm(((1-SO2_tube_linear)*spectrum_Hb + SO2_tube_linear * spectrum_HbO2)),'LineWidth',2);
legend('PA_spectra',['Linear_Unmixing' num2str(SO2_tube_linear) ]);

%%
%SO2_gold = [0,0.2659,0.53806,0.77716,1];
load(  ['Phantom_experiment' '\' 'MC_light_model' '\' 'ColorBase_s' '\' 'ColorBase_s.mat' ] ) ;

%Compensation for water absorption
water_reversal_compensation = 1./exp( - spectrum_H2O * 8.5);

clear spectrum_mean_array  spectrum_std_array  spectrum_absorp spectrum_fluence
load(  ['Phantom_experiment' '\' 'Data' '\' 'PAspectra_withdraw' '\' '0%.mat' ] ) ;
spectrum_mean_array(1,:) = spectrum_mean.*water_reversal_compensation;
spectrum_std_array(1,:)  = spectrum_std.*water_reversal_compensation;
spectrum_absorp(1,:)     = spectrum_Hb * (1 - SO2_gold(1)) + spectrum_HbO2 * SO2_gold(1);
spectrum_fluence(1, :)   = spectrum_mean ./ spectrum_absorp(1,:).*water_reversal_compensation;


load(  ['Phantom_experiment' '\' 'Data' '\' 'PAspectra_withdraw' '\' '25%.mat' ] ) ;
spectrum_mean_array(2,:) = spectrum_mean.*water_reversal_compensation;
spectrum_std_array(2,:)  = spectrum_std.*water_reversal_compensation;
spectrum_absorp(2,:)     = spectrum_Hb * (1 - SO2_gold(2)) + spectrum_HbO2 * SO2_gold(2);
spectrum_fluence(2, :)   = spectrum_mean ./ spectrum_absorp(2,:).*water_reversal_compensation;


load(  ['Phantom_experiment' '\' 'Data' '\' 'PAspectra_withdraw' '\' '50%.mat' ] ) ;
spectrum_mean_array(3,:) = spectrum_mean.*water_reversal_compensation;
spectrum_std_array(3,:)  = spectrum_std.*water_reversal_compensation;
spectrum_absorp(3,:)     = spectrum_Hb * (1 - SO2_gold(3)) + spectrum_HbO2 * SO2_gold(3);
spectrum_fluence(3, :)   = spectrum_mean ./ spectrum_absorp(3,:).*water_reversal_compensation;


load(  ['Phantom_experiment' '\' 'Data' '\' 'PAspectra_withdraw' '\' '75%.mat' ] ) ;
spectrum_mean_array(4,:) = spectrum_mean.*water_reversal_compensation;
spectrum_std_array(4,:)  = spectrum_std.*water_reversal_compensation;
spectrum_absorp(4,:)     = spectrum_Hb * (1 - SO2_gold(4)) + spectrum_HbO2 * SO2_gold(4);
spectrum_fluence(4, :)   = spectrum_mean ./ spectrum_absorp(4,:).*water_reversal_compensation;


load(  ['Phantom_experiment' '\' 'Data' '\' 'PAspectra_withdraw' '\' '100%.mat' ] ) ;
spectrum_mean_array(5,:) = spectrum_mean.*water_reversal_compensation;
spectrum_std_array(5,:)  = spectrum_std.*water_reversal_compensation;
spectrum_absorp(5,:)     = spectrum_Hb * (1 - SO2_gold(5)) + spectrum_HbO2 * SO2_gold(5);
spectrum_fluence(5, :)   = spectrum_mean ./ spectrum_absorp(5,:).*water_reversal_compensation;


figure
for i = 1 : size( spectrum_fluence, 1 )
    
    subplot(1,5,i)
    plot(spectrum_mean_array(i,:)/norm(spectrum_mean_array(i,:)));
    hold on
    plot(spectrum_absorp(i,:)/norm(spectrum_absorp(i,:)));
    hold on
    plot(spectrum_fluence(i, :)/norm(spectrum_fluence(i, :)));
     
end

name_array{ 1 } = '0%.mat';
name_array{ 2 } = '25%.mat';
name_array{ 3 } = '50%.mat';
name_array{ 4 } = '75%.mat';
name_array{ 5 } = '100%.mat';

wavelength = 700 : 10 : 900;
figure
plot(wavelength, colorbase(1:100:end,:)'./sum(colorbase(1:100:end,:)'),'Color',[0.6,0.6,0.6]);
hold on
for i = 1 : size(spectrum_fluence,1)
    plot(wavelength,spectrum_fluence(i,:)/sum(spectrum_fluence(i,:)),'LineWidth',1.5);
    hold on
end
%%
%calculate sNi

wavelength_shoose = 1 : 1 : 21;

tic

for i = 1 : size(spectrum_mean_array,1)
  
    i
    
  [SO2_array(i), Angle, Angle_lv, NearestPA, flags] = convexConeSO2_noise...
                        ( spectrum_mean_array(i,wavelength_shoose), spectrum_Hb(wavelength_shoose), spectrum_HbO2(wavelength_shoose), colorbase(:,wavelength_shoose),spectrum_std_array(i,wavelength_shoose) );
                         
   [SO2_beyas(i), P_post] = convexConeSO2_bayes( spectrum_mean_array(i,wavelength_shoose), Angle, spectrum_std_array(i,wavelength_shoose) );
                                
    Nearest_PA_array{i} = NearestPA;
    Angle_array{i}      = Angle;
    Angle_min  (i)      = min(Angle);
    P_post_array{i}     = P_post;
    
    SO2_linear_array(i) = linearUnmixing( spectrum_mean_array(i,wavelength_shoose), spectrum_HbO2(wavelength_shoose), spectrum_Hb(wavelength_shoose) );
   
end

toc
mean(abs(SO2_beyas- SO2_gold))
mean(abs(SO2_linear_array- SO2_gold))

save( ['Phantom_experiment' '\' 'Results\' 'Results_phantom.mat'  ] );
