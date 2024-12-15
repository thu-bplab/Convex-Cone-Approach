%%
%
clear all
clc

datapath = 'X:\HD1\zzz\华为云服务器\人体NIRS_PA_结合测试\NC_rebuttal\code\Convex_cone_artical_decision';
savepath = 'X:\HD1\zzz\华为云服务器\人体NIRS_PA_结合测试\NC_rebuttal\code\Convex_cone_artical_decision';
addpath( genpath( datapath ) );
load( [ datapath '\' 'Phantom_experiment' '\' 'Results' '\' 'Results_phantom.mat' ] );

%%
%展示光谱拟合能力
width = 1.2;

figure

for i = 1 : size(spectrum_mean_array,1)
    
    subplot(1,5,i)
    
    NearestPA = Nearest_PA_array{i};
    index = round( SO2_beyas(i) * 201 );
    
    if index == 0 
        index = 1;
    end
       
    plot(700 : 10 : 900, spectrum_mean_array(i,:)/norm( spectrum_mean_array(i,:) ),'Linewidth',width,'Color',[10,123,183]/256 );
    hold on
    plot(700 : 10 : 900,  NearestPA(:,index) /norm(  NearestPA(:,index)  ),'--','Linewidth',width,'Color',[128,205,193/2]/256 );
    hold on
    plot(700 : 10 : 900,  ( spectrum_HbO2 * SO2_linear_array(i) + spectrum_Hb * ( 1 - SO2_linear_array(i) ) )  /...
                      norm(   ( spectrum_HbO2 * SO2_linear_array(i) + spectrum_Hb * ( 1 - SO2_linear_array(i) ) )  ),'Linewidth',width,'Color',[224,132,105]/256 );
    
    set(gca,'ylim',[0.05,0.35]);set(gca, 'XTick', [700 800 900], 'YTick', [0.05,0.1,0.15,0.2,0.25,0.3,0.35]);

    set(gca,'LineWidth',1,'GridColor',[0 0 0],'AmbientLightColor',[0 0 0],'XColor',[0 0 0],'YColor',[0 0 0],'TickDir','out',...
    'TickLength',[0.02 0.025]);
     box(gca,'off')

end

figure

ss = 0:0.5:100;
for i = 1 : length(Angle_array)
    
    subplot(1,5,i);
    plot(ss,Angle_array{i},'Linewidth',width,'Color',[128,205,193]/256);  
    hold on
    plot( [SO2_beyas(i)*100, SO2_beyas(i)*100],[0, 0.25],'--','Linewidth',width,'Color',[0,0,0]/256 );
    set(gca,'ylim',[0,0.3],'xlim',[-1,100],'LineWidth',1,'GridColor',[0 0 0],'AmbientLightColor',[0 0 0],'XColor',[0 0 0],'YColor',[0 0 0],'TickDir','out',...
    'TickLength',[0.02 0.025]);
    box(gca,'off')
     
end
%%
%展示重建图像
Image_800_show = Image_800(300 : end,:);
%Image_800_show( 480 : 485, 680 : 780 ) = 0.8 * max( Image_800_show( : ) ); 

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
skin_muscle_3D = zeros(300,300,300);
skin_muscle_buffer = skin_muscle;

skin_muscle_buffer(skin_muscle_buffer>=9) = 0;

for k = 2 : 8 
        skin_muscle_buffer(skin_muscle_buffer==k) = 100 * ( (rand-0.5) * 0.9 + 0.55 );
end

skin_muscle_buffer(skin_muscle_buffer==1) = 5;  

for i = 1 : size(skin_muscle_3D,3)
    skin_muscle_3D(:,:,i) = skin_muscle_buffer; 
end

figure
imagesc(skin_muscle_3D(:,:,1));

load('X:\HD1\zzz\华为云服务器\人体NIRS_PA_结合测试\NC_rebuttal\code\Convex_cone_artical_decision\Phantom_experiment\Image\Config.phantom_volume_viewer.mat');
% show 3d image on screen
h = volshow(skin_muscle_3D,'Colormap',config.Colormap,'Alphamap',config.Alphamap,'BackgroundColor',[1,1,1],'Render','VolumeRendering');
%set(gcf,'position',[1,1,800,800])
%set(gca,'looseInset',[0 0 0 0]);
% set camera position
h.CameraPosition = config.CameraPosition;
h.CameraUpVector = config.CameraUpVector;
h.CameraUpVector = [0,0,1];

% h.CameraUpVector = [1 0 0];
h.CameraViewAngle = config.CameraViewAngle;
h.CameraTarget    = config.CameraTarget
h.ScaleFactors    = [1 1 1];
h.Lighting    

%%
phantom = imread('Z:\zzz\convex-cone论文\改进第八版\Phantom.jpg');
figure
imshow(phantom);

phantom_3D = zeros( size(phantom,1), size(phantom,2), 1000 );

phantom_buffer = double(phantom(:, :, 2));

phantom_buffer(abs( phantom_buffer-87 )<=2 ) = 25;
phantom_buffer(abs( phantom_buffer-130)<=2 ) = 50;
phantom_buffer(abs( phantom_buffer-160)<=2 ) = 75;
phantom_buffer(abs( phantom_buffer-209)<=2 ) = 100;
phantom_buffer(abs( phantom_buffer-209)<=2) = 100;
phantom_buffer(abs( phantom_buffer-224)<=2) = 50;
phantom_buffer(abs( phantom_buffer-249)<=2) = 10;
phantom_buffer(phantom_buffer>=240) =0;
phantom_buffer( phantom_buffer>100)  = 5;

seg_domain_array = zeros( size(phantom_buffer) );
figure
imagesc(phantom_buffer)

for i = 1 : 7
    seg_domain=seg_manual(phantom_buffer,1);
    seg_domain_array = seg_domain_array + seg_domain;
end

index = ( seg_domain_array ==1 ).*( (phantom_buffer~=0) & (phantom_buffer~=5) );
phantom_buffer(index==1) = 5;
%%
phantom_buffer_1 = phantom_buffer;
X_array    = [577,903,577,740,903];
Y_array    = [535,535,727,727,727];

for i = 1 : length(X_array)
    
    ee = makeDisc(size(phantom_buffer,1), size(phantom_buffer,2), Y_array(i), X_array(i),15);
    index = find( ee~=0 );
    if i == 1 
        phantom_buffer_1( index ) = 10;
    else
        phantom_buffer_1( index ) = 100 * SO2_gold(i);
    end
end

figure
imagesc(phantom_buffer_1);
axis image
%%
figure
imagesc(seg_domain_array);


figure
imagesc(phantom(:,:,2));
figure
imagesc(phantom_buffer_1);

for i = 1 : size(phantom_3D,3)

    phantom_3D(:,:,i) = phantom_buffer_1;
    
end
%%
figure
load('Y:\HD1\zzz\华为云服务器\人体NIRS_PA_结合测试\NC_rebuttal\code\Convex_cone_artical_decision\Phantom_experiment\Image\Config.phantom_volume_viewer.mat');
% show 3d image on screen
h = volshow(phantom_3D,'Colormap',config.Colormap,'Alphamap',config.Alphamap,'BackgroundColor',[1,1,1],'Render','VolumeRendering');
%set(gcf,'position',[1,1,800,800])
set(gca,'looseInset',[0 0 0 0]);
% set camera position
h.CameraPosition = config.CameraPosition;
h.CameraUpVector = config.CameraUpVector;
% h.CameraUpVector = [1 0 0];
h.CameraViewAngle = config.CameraViewAngle;
h.CameraTarget    = config.CameraTarget
h.ScaleFactors    = [1 1 1];
h.Lighting        = 1;

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
set(gca,'LineWidth',1.2,'GridColor',[0 0 0],'AmbientLightColor',[0 0 0],'XColor',[0 0 0],'YColor',[0 0 0],'TickDir','out',...
    'TickLength',[0.02 0.025]);
%%
figure
plot(spectrum_Hb/max(spectrum_HbO2),'color',[0.30,0.75,0.93]*0.9, 'LineWidth',3 );
hold on
plot(spectrum_HbO2/max(spectrum_HbO2),'color',[0.47,0.67,0.19], 'LineWidth',3 );
ylim([0,1])
set(gca,'XTick',[700 800 900],'YTick',[0 1]);
hold(gca,'off');

%%
figure  
plot( 700 : 10 : 900,  spectrum_25 /sum(spectrum_25), 'LineWidth',3,'Color','b' );
hold on
plot( 700 : 10 : 900, ( SO2_gold(2) * spectrum_HbO2 + ( 1 - SO2_gold(2) ) * spectrum_Hb ) /...
       sum( ( SO2_gold(2) * spectrum_HbO2 + ( 1 - SO2_gold(2) ) * spectrum_Hb ) ),'--', 'LineWidth', 3,'Color','r' );

hold on
plot( 700 : 10 : 900, spectrum_50 /sum(spectrum_50), 'LineWidth',3,'Color','b' );
hold on
plot( 700 : 10 : 900,  ( SO2_gold(3) * spectrum_HbO2 + ( 1 - SO2_gold(3) ) * spectrum_Hb ) /...
       sum( ( SO2_gold(3) * spectrum_HbO2 + ( 1 - SO2_gold(3) ) * spectrum_Hb ) ),'--', 'LineWidth', 3,'Color','r' );

hold on
plot( 700 : 10 : 900, spectrum_75 /sum(spectrum_75), 'LineWidth',3,'Color','b' );
hold on
plot( 700 : 10 : 900, ( SO2_gold(4) * spectrum_HbO2 + ( 1 - SO2_gold(4) ) * spectrum_Hb ) /...
       sum( ( SO2_gold(4) * spectrum_HbO2 + ( 1 - SO2_gold(4) ) * spectrum_Hb ) ),'--', 'LineWidth', 3,'Color','r' );

%%
figure
plot(700 : 10 : 900, colorbase(1 : 10 : end, :)'./sum(colorbase(1 : 10 : end, :)'),'Color',[0.6,0.6,0.6]);

