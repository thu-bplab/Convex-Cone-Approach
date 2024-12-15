%%
clear all
clc

datapath = 'X:\HD6\zzz\华为云服务器\人体NIRS_PA_结合测试\NC_rebuttal\code\Convex_cone_open';
savepath = 'X:\HD6\zzz\华为云服务器\人体NIRS_PA_结合测试\NC_rebuttal\code\Convex_cone_open';
addpath( genpath( datapath ) );


%load absroption spectrum
load( [ datapath '\' 'Substance_spectra\spectrumCuSO4_extin.mat' ] );
load( [ datapath,'\' 'Substance_spectra\spectrumNiSO4_extin.mat' ] );
load( [ datapath,'\' 'Substance_spectra\spectrum_H2O.mat' ] );

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

load([datapath '\' 'Phantom_experiment' '\' 'Data' '\' '原始数据' '\' 'Tube_linear_unmixing' '\' 'standard_image_25_75.mat'] );
correct = spectrum_extin_CuSO4./mean(spectrum_norm);
load([datapath '\' 'Phantom_experiment' '\' 'Data' '\' '原始数据' '\' 'Tube_linear_unmixing' '\' 'Cu_Ni_25_image.mat'] );
spectrum_25 = correct.*mean(spectrum_norm(1:7,:));%
SO2_tube_linear = linearUnmixing(spectrum_25, spectrum_HbO2, spectrum_Hb);
SO2_gold(2) = SO2_tube_linear;

figure
plot(700 : 10 : 900,spectrum_25/norm(spectrum_25),'LineWidth',2);
hold on
plot(700 : 10 : 900, ((1-SO2_tube_linear)*spectrum_Hb + SO2_tube_linear * spectrum_HbO2)/norm(((1-SO2_tube_linear)*spectrum_Hb + SO2_tube_linear* spectrum_HbO2)),'LineWidth',2);
legend('光声光谱',['线性解混拟合' num2str(SO2_tube_linear) ]);


load([datapath '\' 'Phantom_experiment' '\' 'Data' '\' '原始数据' '\' 'Tube_linear_unmixing' '\' 'standard_image_50.mat'] );
correct = spectrum_extin_CuSO4./mean(spectrum_norm);
load([datapath '\' 'Phantom_experiment' '\' 'Data' '\' '原始数据' '\' 'Tube_linear_unmixing' '\' 'Cu_Ni_50_image.mat'] );
spectrum_50 = correct.*mean(spectrum_norm);
SO2_tube_linear = linearUnmixing(spectrum_50, spectrum_HbO2, spectrum_Hb);
SO2_gold(3) = SO2_tube_linear;

figure
plot(700 : 10 : 900,spectrum_50/norm(spectrum_50),'LineWidth',2);
hold on
plot(700 : 10 : 900,((1-SO2_tube_linear)*spectrum_Hb + SO2_tube_linear * spectrum_HbO2)/norm(((1-SO2_tube_linear)*spectrum_Hb + SO2_tube_linear * spectrum_HbO2)),'LineWidth',2);
legend('光声光谱',['线性解混拟合' num2str(SO2_tube_linear) ]);


load([datapath '\' 'Phantom_experiment' '\' 'Data' '\' '原始数据' '\' 'Tube_linear_unmixing' '\' 'standard_image_25_75.mat'] );
correct = spectrum_extin_CuSO4./mean(spectrum_norm);
load([datapath '\' 'Phantom_experiment' '\' 'Data' '\' '原始数据' '\' 'Tube_linear_unmixing' '\' 'Cu_Ni_75_image.mat'] );
spectrum_75 = correct.*mean(spectrum_norm);
SO2_tube_linear = linearUnmixing(spectrum_75, spectrum_HbO2, spectrum_Hb);
SO2_gold(4) = SO2_tube_linear;

figure
plot(700 : 10 : 900,spectrum_75/norm(spectrum_75),'LineWidth',2);
hold on
plot(700 : 10 : 900,((1-SO2_tube_linear)*spectrum_Hb + SO2_tube_linear * spectrum_HbO2)/norm(((1-SO2_tube_linear)*spectrum_Hb + SO2_tube_linear * spectrum_HbO2)),'LineWidth',2);
legend('光声光谱',['线性解混拟合' num2str(SO2_tube_linear) ]);

%线性解混测得溶液真值
%SO2_gold = [0,0.2659,0.53806,0.77716,1];
load(  [ datapath '\' 'Phantom_experiment' '\' 'MC_light_model' '\' 'ColorBase_s' '\' 'ColorBase_s.mat' ] ) ;

%补偿水的吸收
water_reversal_compensation = 1./exp( - spectrum_H2O * 8.5);

clear spectrum_mean_array  spectrum_std_array  spectrum_absorp spectrum_fluence
load(  [ datapath '\' 'Phantom_experiment' '\' 'Data' '\' '光谱导出' '\' '0%.mat' ] ) ;
spectrum_mean_array(1,:) = spectrum_mean.*water_reversal_compensation;
spectrum_std_array(1,:)  = spectrum_std.*water_reversal_compensation;
spectrum_absorp(1,:)     = spectrum_Hb * (1 - SO2_gold(1)) + spectrum_HbO2 * SO2_gold(1);
spectrum_fluence(1, :)   = spectrum_mean ./ spectrum_absorp(1,:).*water_reversal_compensation;
Mask_array_diff{ 1 }     = Mask;
X_array_diff( 1 )        = X;
Y_array_diff( 1 )        = Y;
start_ex_array ( 1 )     = start_ex;

load(  [ datapath '\' 'Phantom_experiment' '\' 'Data' '\' '光谱导出' '\' '25%.mat' ] ) ;
spectrum_mean_array(2,:) = spectrum_mean.*water_reversal_compensation;
spectrum_std_array(2,:)  = spectrum_std.*water_reversal_compensation;
spectrum_absorp(2,:)     = spectrum_Hb * (1 - SO2_gold(2)) + spectrum_HbO2 * SO2_gold(2);
spectrum_fluence(2, :)   = spectrum_mean ./ spectrum_absorp(2,:).*water_reversal_compensation;
Mask_array_diff{ 2 }     = Mask;
X_array_diff( 2 )        = X;
Y_array_diff( 2 )        = Y;
start_ex_array ( 2 )     = start_ex;

load(  [ datapath '\' 'Phantom_experiment' '\' 'Data' '\' '光谱导出' '\' '50%.mat' ] ) ;
spectrum_mean_array(3,:) = spectrum_mean.*water_reversal_compensation;
spectrum_std_array(3,:)  = spectrum_std.*water_reversal_compensation;
spectrum_absorp(3,:)     = spectrum_Hb * (1 - SO2_gold(3)) + spectrum_HbO2 * SO2_gold(3);
spectrum_fluence(3, :)   = spectrum_mean ./ spectrum_absorp(3,:).*water_reversal_compensation;
Mask_array_diff{ 3 }     = Mask;
X_array_diff( 3 )        = X;
Y_array_diff( 3 )        = Y;
start_ex_array ( 3 )     = start_ex;

load(  [ datapath '\' 'Phantom_experiment' '\' 'Data' '\' '光谱导出' '\' '75%.mat' ] ) ;
spectrum_mean_array(4,:) = spectrum_mean.*water_reversal_compensation;
spectrum_std_array(4,:)  = spectrum_std.*water_reversal_compensation;
spectrum_absorp(4,:)     = spectrum_Hb * (1 - SO2_gold(4)) + spectrum_HbO2 * SO2_gold(4);
spectrum_fluence(4, :)   = spectrum_mean ./ spectrum_absorp(4,:).*water_reversal_compensation;
Mask_array_diff{ 4 }     = Mask;
X_array_diff( 4 )        = X;
Y_array_diff( 4 )        = Y;
start_ex_array ( 4 )     = start_ex;

load(  [ datapath '\' 'Phantom_experiment' '\' 'Data' '\' '光谱导出' '\' '100%.mat' ] ) ;
spectrum_mean_array(5,:) = spectrum_mean.*water_reversal_compensation;
spectrum_std_array(5,:)  = spectrum_std.*water_reversal_compensation;
spectrum_absorp(5,:)     = spectrum_Hb * (1 - SO2_gold(5)) + spectrum_HbO2 * SO2_gold(5);
spectrum_fluence(5, :)   = spectrum_mean ./ spectrum_absorp(5,:).*water_reversal_compensation;
Mask_array_diff{ 5 }     = Mask;
X_array_diff( 5 )        = X;
Y_array_diff( 5 )        = Y;
start_ex_array ( 5 )     = start_ex;

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

%解算血氧饱和度（实验数据集）


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

save( [ datapath '\' 'Phantom_experiment' '\' 'Results\' 'Results_phantom.mat'  ] );
%%
%展示光谱拟合能力
width = 1.8;

figure

for i = 1 : size(spectrum_mean_array,1)
    
    subplot(1,5,i)
    
    NearestPA = Nearest_PA_array{i};
    index = round( SO2_beyas(i) * 201 );
    
    if index == 0 
        index = 1;
    end
       
    plot(700 : 10 : 900, spectrum_mean_array(i,:)/norm( spectrum_mean_array(i,:) ),'Linewidth',width,'Color','b' );
    hold on
    plot(700 : 10 : 900,  NearestPA(:,index) /norm(  NearestPA(:,index)  ),'--','Linewidth',width,'Color',[0.93,0.69,0.13] );
    hold on
    plot(700 : 10 : 900,  ( spectrum_HbO2 * SO2_linear_array(i) + spectrum_Hb * ( 1 - SO2_linear_array(i) ) )  /...
                      norm(   ( spectrum_HbO2 * SO2_linear_array(i) + spectrum_Hb * ( 1 - SO2_linear_array(i) ) )  ),'Linewidth',width,'Color','r');
    
     set(gca,'ylim',[0.05,0.35]);set(gca, 'XTick', [700 800 900], 'YTick', [0.05,0.35]);

    
end


%%
%展示重建图像
Image_800_show = Image_800(300 : end,:);
Image_800_show( 480 : 485, 680 : 780 ) = 0.8 * max( Image_800_show( : ) ); 

figure
imagesc( Image_800_show );
set( gca,'Clim',[ 0.01 * max(max(Image_800_show(:))),0.7 * max(max(Image_800_show(:))) ] );
axis image
axis off
colormap gray

load( [ datapath '\' 'rainbow_colormap' ] );
cm = C;
cm(1,:)   = [0,0,0];
cm(end,:) = [256,256,256];
skin_muscle_show = skin_muscle(1:250,:);
skin_muscle_show( skin_muscle_show == 9 ) = 0;
skin_muscle_show( end-19 : end-17, 230 : 280 ) =  9;

figure
imagesc(skin_muscle_show);
axis image
colormap(cm)
axis off
%%
%----------------------------------------------------------------------------------------------%
%
%展示解算结果
%
%----------------------------------------------------------------------------------------------%
figure
scatter( SO2_gold * 100, SO2_linear_array * 100,'MarkerEdgeAlpha',0.5,'MarkerEdgeColor',[1 0 0],...
    'AlphaData',1,...
    'MarkerFaceAlpha',0.5,...
    'MarkerFaceColor',[0.8311,0.1067,0.0889],...
    'SizeData',50);
hold on
scatter( SO2_gold * 100, SO2_beyas * 100, 'MarkerEdgeAlpha',1,'MarkerEdgeColor',[0 0 1],...
'AlphaData',1,...
'MarkerFaceAlpha',1,...
'MarkerFaceColor',[0,0.4196,0.6745],...
'SizeData',50);

hold on

plot(0:1:100,0:1:100,'--','LineWidth',1.5,'Color','g');
%axis image

ylabel({'test-sO2'},'FontWeight','bold','FontSize',12);

% 创建 xlabel
xlabel({'gold-sO2'},'FontWeight','bold','FontSize',12);

set(gca,'DataAspectRatio',[1 1 1],'FontWeight','bold','XTick',...
    [0 20 40 60 80 100],'YTick',[0 20 40 60 80 100]);

set(gca,'DataAspectRatio',[1 1 1],'FontWeight','bold');
axis(gca,'tight');
hold(gca,'off');
legend1 = legend(gca,[ 'Linear-unmixing ' num2str( roundn( mean(abs(SO2_linear_array - SO2_gold)) * 100, -1 ) )  '%' ],[ 'Convex-cone ' num2str( roundn( mean(abs(SO2_beyas- SO2_gold)) * 100, -1 ) ) '%'  ],'Gold-standard');
set(legend1,...
    'Position',[0.535652919601563 0.207302706542088 0.133100149329527 0.128386339394308],...
    'EdgeColor',[1 1 1]);

