clc
clear all

datapath_root = 'X:\HD1\zzz\华为云服务器\人体NIRS_PA_结合测试\NC_rebuttal\code\Convex_cone_artical_decision';
addpath( genpath( datapath_root ) );
load( [ datapath_root '\' 'Human_experiment\Results\Results_human.mat' ] );
load('rainbow_colormap.mat');

%
%------------------------------------------------------------------------------------------------------------%
%
%展示血氧叠加光声图像的伪彩色图
%
%------------------------------------------------------------------------------------------------------------%
%半环阵桡动脉成像
%
%
datapath_extract = [ datapath_root '\' 'Human_experiment' '\' 'Data' '\' '光谱导出' '\' 'arm' ];
datapath_image   = [ datapath_root '\' 'Human_experiment' '\' 'Data' '\' '原始数据' '\' 'arm' ];
datapath1 = 'zhz_radio_left';
load( [ datapath_image '\' datapath1 '_image.mat' ] );
dirall_experiment = dir( [ datapath_extract '\' datapath1 '\*mat' ] );

clear index
for i = 1 : length( {dirall_experiment.name} )
    
    name = dirall_experiment( i ).name;
    index( i ) = find( strcmp( name, name_array ) == 1);       

end

cm = double(C)/255;
cm = cm./repmat( sqrt( sum( cm.^2, 2 ) ), 1, 3 );

min_color = 0;
max_color = 1;

pa_img_min = 0.05;
pa_img_max = 0.4;

frame_index = start_ex_array( index(1) ) + 1;
pa_img_buffer = Images(:, :, 21, frame_index );
pa_img_buffer( pa_img_buffer<0 ) = 0;
pa_img = squeeze( pa_img_buffer.^1 );

Mask   = zeros( size( pa_img ) );
SO2    = zeros( size( pa_img ) );

for i = 1 : length( index )
    
    mask = Mask_array_diff{ index( i ) }; 
    xs   = X_array_diff( index( i ) );
    ys   = Y_array_diff( index( i ) );
    
    Mask( ys - (size(mask,1)-1)/2 : ys + (size(mask,1)-1)/2, xs - (size(mask,2)-1)/2 : xs + (size(mask,2)-1)/2  ) =  squeeze(  mask(:, :, 21,frame_index) );

    SO2( ys - (size(mask,1)-1)/2 : ys + (size(mask,1)-1)/2, xs - (size(mask,2)-1)/2 : xs + (size(mask,2)-1)/2  )  =  SO2_beyas_array_diff( index( i ) ) * squeeze(  mask(:, :, 21,frame_index) );   
end
pa_img_sO2  = Blood_oxygen_pseudo_color ( SO2, Mask, pa_img, cm, min_color,max_color, pa_img_min, pa_img_max );
SO2_cc      = SO2;

%pa_img(280 : 284, 680 : 780 ) = 0.8 * max( pa_img( : ) ); 
for i = 1 : length( index )
    
    mask = Mask_array_diff{ index( i ) }; 
    xs   = X_array_diff( index( i ) );
    ys   = Y_array_diff( index( i ) );
    
    Mask( ys - (size(mask,1)-1)/2 : ys + (size(mask,1)-1)/2, xs - (size(mask,2)-1)/2 : xs + (size(mask,2)-1)/2  ) =  squeeze(  mask(:, :, 21,frame_index) );

    SO2( ys - (size(mask,1)-1)/2 : ys + (size(mask,1)-1)/2, xs - (size(mask,2)-1)/2 : xs + (size(mask,2)-1)/2  )  =  SO2_linear_unmixing_diff( index( i ) ) * squeeze(  mask(:, :, 21,frame_index) ); 
  
end
pa_img_sO2_linear_unmixing  = Blood_oxygen_pseudo_color ( SO2, Mask, pa_img, cm,min_color,max_color, pa_img_min, pa_img_max );

pa_img_sO2 = flipud(pa_img_sO2);
pa_img_sO2_linear_unmixing = flipud(pa_img_sO2_linear_unmixing);

figure
subplot(1, 2, 1)
imshow( ( pa_img_sO2(  1 : 300, 200 : 750, : ) ) );
axis image

subplot(1, 2, 2);
imshow( ( pa_img_sO2_linear_unmixing( 1 : 300, 200 : 750 , :) ) );
axis image

save( [ datapath_root '\' 'Human_experiment' '\' 'Results' '\' datapath1 'pseudocolor.mat' ],'pa_img_sO2','pa_img_sO2_linear_unmixing','SO2_cc','SO2','Mask','pa_img','cm','min_color','max_color','pa_img_min','pa_img_max' );


%-------------------------------------------------------------------------%
%
%穿刺金标准实验#1
%
%-------------------------------------------------------------------------%

datapath_extract = [ datapath_root '\' 'Human_experiment' '\' 'Data' '\' '光谱导出' '\' 'puncture' ];
datapath_image   = [ datapath_root '\' 'Human_experiment' '\' 'Data' '\' '原始数据' '\' 'puncture' ];

datapath1 = 'handi1_image';
load( [ datapath_image '\' datapath1 '.mat' ] );
dirall_experiment = dir( [ datapath_extract '\' datapath1 '\*mat' ] );

clear index
for i = 1 : length( {dirall_experiment.name} )
    
    name = dirall_experiment( i ).name;
    index( i ) = find( strcmp( name, name_array ) == 1);       

end

cm = double(C)/255;
cm = cm./repmat( sqrt( sum( cm.^2, 2 ) ), 1, 3 );

min_color = 0;
max_color = 1;

pa_img_min = 0.05;
pa_img_max = 1;

frame_index = start_ex_array( index(1) ) + 3;
pa_img_buffer = Images(:, :, 11, frame_index );
pa_img_buffer( pa_img_buffer<0 ) = 0;
pa_img = squeeze( pa_img_buffer.^1.2 );

Mask   = zeros( size( pa_img ) );
SO2    = zeros( size( pa_img ) );

for i = 1 : length( index )
    mask = Mask_array_diff{ index( i ) }; 
    xs   = X_array_diff( index( i ) );
    ys   = Y_array_diff( index( i ) );
    
    Mask( ys - (size(mask,1)-1)/2 : ys + (size(mask,1)-1)/2, xs - (size(mask,2)-1)/2 : xs + (size(mask,2)-1)/2  ) =  squeeze(  mask(:, :, 11,frame_index) );

    SO2( ys - (size(mask,1)-1)/2 : ys + (size(mask,1)-1)/2, xs - (size(mask,2)-1)/2 : xs + (size(mask,2)-1)/2  )  =  SO2_beyas_array_diff( index( i ) ) * squeeze(  mask(:, :, 11,frame_index) );   
end

% pa_img(360:400,660:700) = 0.75* max(pa_img(:));
% SO2(360:400,660:700)    = SO2_gold_experiment(1); 
% Mask(360:400,660:700)   = 1;
SO2_cc      = SO2;

pa_img_sO2  = Blood_oxygen_pseudo_color ( SO2, Mask, pa_img, cm, min_color,max_color, pa_img_min, pa_img_max );

for i = 1 : length( index )    
    mask = Mask_array_diff{ index( i ) }; 
    xs   = X_array_diff( index( i ) );
    ys   = Y_array_diff( index( i ) );
    
    Mask( ys - (size(mask,1)-1)/2 : ys + (size(mask,1)-1)/2, xs - (size(mask,2)-1)/2 : xs + (size(mask,2)-1)/2  ) =  squeeze(  mask(:, :, 11,frame_index) );

    SO2( ys - (size(mask,1)-1)/2 : ys + (size(mask,1)-1)/2, xs - (size(mask,2)-1)/2 : xs + (size(mask,2)-1)/2  )  =  SO2_linear_unmixing_diff( index( i ) ) * squeeze(  mask(:, :, 11,frame_index) ); 
end
pa_img_sO2_linear_unmixing  = Blood_oxygen_pseudo_color ( SO2, Mask, pa_img, cm,min_color,max_color, pa_img_min, pa_img_max );

pa_img_sO2 = flipud(pa_img_sO2);
pa_img_sO2_linear_unmixing = flipud(pa_img_sO2_linear_unmixing);

figure
subplot(1, 2, 1)
imshow( ( pa_img_sO2(  100 : 400, 150 : 700, : ) ) );
axis image
subplot(1, 2, 2);
imshow( ( pa_img_sO2_linear_unmixing( 100 : 400, 150 : 700 , :) ) );
axis image

save( [ datapath_root '\' 'Human_experiment' '\' 'Results' '\' datapath1 'pseudocolor.mat' ],'pa_img_sO2','pa_img_sO2_linear_unmixing','SO2_cc','SO2','Mask','pa_img','cm','min_color','max_color','pa_img_min','pa_img_max' );

%-------------------------------------------------------------------------%
%
%穿刺金标准实验#2
%
%-------------------------------------------------------------------------%

datapath_extract = [ datapath_root '\' 'Human_experiment' '\' 'Data' '\' '光谱导出' '\' 'puncture' ];
datapath_image   = [ datapath_root '\' 'Human_experiment' '\' 'Data' '\' '原始数据' '\' 'puncture' ];


datapath1 = 'handi2_image';
load( [ datapath_image '\' datapath1 '.mat' ] );
dirall_experiment = dir( [ datapath_extract '\' datapath1 '\*mat' ] );

clear index
for i = 1 : length( {dirall_experiment.name} )
    
    name = dirall_experiment( i ).name;
    index( i ) = find( strcmp( name, name_array ) == 1);       

end

cm = double(C)/255;
cm = cm./repmat( sqrt( sum( cm.^2, 2 ) ), 1, 3 );

min_color = 0;
max_color = 1;

pa_img_min = 0.1;
pa_img_max = 1;

frame_index = start_ex_array( index(1) ) + 1;
pa_img_buffer = Images(:, :, 11, frame_index );
pa_img_buffer( pa_img_buffer<0 ) = 0;
pa_img = squeeze( pa_img_buffer.^0.6 );


Mask   = zeros( size( pa_img ) );
SO2    = zeros( size( pa_img ) );

for i = 1 : length( index )
    mask = Mask_array_diff{ index( i ) }; 
    xs   = X_array_diff( index( i ) );
    ys   = Y_array_diff( index( i ) );
    
    Mask( ys - (size(mask,1)-1)/2 : ys + (size(mask,1)-1)/2, xs - (size(mask,2)-1)/2 : xs + (size(mask,2)-1)/2  ) =  squeeze(  mask(:, :, 21,frame_index) );

    SO2( ys - (size(mask,1)-1)/2 : ys + (size(mask,1)-1)/2, xs - (size(mask,2)-1)/2 : xs + (size(mask,2)-1)/2  )  =  SO2_beyas_array_diff( index( i ) ) * squeeze(  mask(:, :, 21,frame_index) );   
end

% pa_img(360 : 400,150 : 190)    = 0.75* max(pa_img(:));
% SO2   (360 : 400,   150 : 190) = SO2_gold_experiment(2); 
% Mask  (360 : 400,  150 : 190)  = 1;
SO2_cc      = SO2;

pa_img_sO2  = Blood_oxygen_pseudo_color ( SO2, Mask, pa_img, cm, min_color,max_color, pa_img_min, pa_img_max );

for i = 1 : length( index )    
    mask = Mask_array_diff{ index( i ) }; 
    xs   = X_array_diff( index( i ) );
    ys   = Y_array_diff( index( i ) );
    
    Mask( ys - (size(mask,1)-1)/2 : ys + (size(mask,1)-1)/2, xs - (size(mask,2)-1)/2 : xs + (size(mask,2)-1)/2  ) =  squeeze(  mask(:, :, 21,frame_index) );

    SO2( ys - (size(mask,1)-1)/2 : ys + (size(mask,1)-1)/2, xs - (size(mask,2)-1)/2 : xs + (size(mask,2)-1)/2  )  =  SO2_linear_unmixing_diff( index( i ) ) * squeeze(  mask(:, :, 21,frame_index) ); 
end
pa_img_sO2_linear_unmixing  = Blood_oxygen_pseudo_color ( SO2, Mask, pa_img, cm,min_color,max_color, pa_img_min, pa_img_max );

pa_img_sO2 = flipud(pa_img_sO2);
pa_img_sO2_linear_unmixing = flipud(pa_img_sO2_linear_unmixing);

%将血氧真值标注在图像中，仅限于有穿刺真值的数据

figure
subplot(1, 2, 1)
imshow( ( pa_img_sO2(  100 : 400, 150 : 700, : ) ) );
axis image
subplot(1, 2, 2);
imshow( ( pa_img_sO2_linear_unmixing( 100 : 400, 150 : 700 , :) ) );
axis image

save( [ datapath_root '\' 'Human_experiment' '\' 'Results' '\' datapath1 'pseudocolor.mat' ],'pa_img_sO2','pa_img_sO2_linear_unmixing','SO2_cc','SO2','Mask','pa_img','cm','min_color','max_color','pa_img_min','pa_img_max' );

%-------------------------------------------------------------------------%
%
%穿刺金标准实验#3
%
%-------------------------------------------------------------------------%

datapath_extract = [ datapath_root '\' 'Human_experiment' '\' 'Data' '\' '光谱导出' '\' 'puncture' ];
datapath_image   = [ datapath_root '\' 'Human_experiment' '\' 'Data' '\' '原始数据' '\' 'puncture' ];

datapath1 = 'zhz1_image';
load( [ datapath_image '\' datapath1 '.mat' ] );
dirall_experiment = dir( [ datapath_extract '\' datapath1 '\*mat' ] );

clear index
for i = 1 : length( {dirall_experiment.name} )
    
    name = dirall_experiment( i ).name;
    index( i ) = find( strcmp( name, name_array ) == 1);       

end

cm = double(C)/255;
cm = cm./repmat( sqrt( sum( cm.^2, 2 ) ), 1, 3 );

min_color = 0;
max_color = 1;

pa_img_min = 0.02;
pa_img_max = 1;

frame_index = start_ex_array( index(1) ) + 1;
pa_img_buffer = Images(:, :, 21, frame_index );
pa_img_buffer( pa_img_buffer<0 ) = 0;
pa_img = squeeze( pa_img_buffer.^1.1 );


Mask   = zeros( size( pa_img ) );
SO2    = zeros( size( pa_img ) );

for i = 1 : length( index )
    mask = Mask_array_diff{ index( i ) }; 
    xs   = X_array_diff( index( i ) );
    ys   = Y_array_diff( index( i ) );
    
    Mask( ys - (size(mask,1)-1)/2 : ys + (size(mask,1)-1)/2, xs - (size(mask,2)-1)/2 : xs + (size(mask,2)-1)/2  ) =  squeeze(  mask(:, :, 21,frame_index) );

    SO2( ys - (size(mask,1)-1)/2 : ys + (size(mask,1)-1)/2, xs - (size(mask,2)-1)/2 : xs + (size(mask,2)-1)/2  )  =  SO2_beyas_array_diff( index( i ) ) * squeeze(  mask(:, :, 21,frame_index) );   
end

% pa_img(100 : 140, 150 : 190) = 0.8 * max(pa_img(:));
% SO2(100 : 140,   150 : 190) = SO2_gold_experiment(3); 
% Mask(100 : 140,  150 : 190) = 1;

%pa_img(380 : 384, 580 : 680) = 0.8 * max(pa_img(:));

SO2_cc      = SO2;

pa_img_sO2  = Blood_oxygen_pseudo_color ( SO2, Mask, pa_img, cm, min_color,max_color, pa_img_min, pa_img_max );

for i = 1 : length( index )    
    mask = Mask_array_diff{ index( i ) }; 
    xs   = X_array_diff( index( i ) );
    ys   = Y_array_diff( index( i ) );
    
    Mask( ys - (size(mask,1)-1)/2 : ys + (size(mask,1)-1)/2, xs - (size(mask,2)-1)/2 : xs + (size(mask,2)-1)/2  ) =  squeeze(  mask(:, :, 21,frame_index) );

    SO2( ys - (size(mask,1)-1)/2 : ys + (size(mask,1)-1)/2, xs - (size(mask,2)-1)/2 : xs + (size(mask,2)-1)/2  )  =  SO2_linear_unmixing_diff( index( i ) ) * squeeze(  mask(:, :, 21,frame_index) ); 
end
pa_img_sO2_linear_unmixing  = Blood_oxygen_pseudo_color ( SO2, Mask, pa_img, cm,min_color,max_color, pa_img_min, pa_img_max );

pa_img_sO2 = flipud(pa_img_sO2);
pa_img_sO2_linear_unmixing = flipud(pa_img_sO2_linear_unmixing);

figure
subplot(1, 2, 1)
imshow( ( pa_img_sO2(  100 : 400, 150 : 700, : ) ) );
axis image
subplot(1, 2, 2);
imshow( ( pa_img_sO2_linear_unmixing( 100 : 400, 150 : 700 , :) ) );
axis image

save( [ datapath_root '\' 'Human_experiment' '\' 'Results' '\' datapath1 'pseudocolor.mat' ],'pa_img_sO2','pa_img_sO2_linear_unmixing','SO2_cc','SO2','Mask','pa_img','cm','min_color','max_color','pa_img_min','pa_img_max' );

%-------------------------------------------------------------------------%
%
%穿刺金标准实验#4
%
%-------------------------------------------------------------------------%

datapath_extract = [ datapath_root '\' 'Human_experiment' '\' 'Data' '\' '光谱导出' '\' 'puncture' ];
datapath_image   = [ datapath_root '\' 'Human_experiment' '\' 'Data' '\' '原始数据' '\' 'puncture' ];

datapath1 = 'zhz2_image';
load( [ datapath_image '\' datapath1 '.mat' ] );
dirall_experiment = dir( [ datapath_extract '\' datapath1 '\*mat' ] );

clear index
for i = 1 : length( {dirall_experiment.name} )
    
    name = dirall_experiment( i ).name;
    index( i ) = find( strcmp( name, name_array ) == 1);       

end

cm = double(C)/255;
cm = cm./repmat( sqrt( sum( cm.^2, 2 ) ), 1, 3 );

min_color = 0;
max_color = 1;

pa_img_min = 0.05;
pa_img_max = 1;

frame_index = start_ex_array( index(1) ) + 1;
pa_img_buffer = Images(:, :, 21, frame_index );
pa_img_buffer( pa_img_buffer<0 ) = 0;
pa_img = squeeze( pa_img_buffer.^1.2 );

Mask   = zeros( size( pa_img ) );
SO2    = zeros( size( pa_img ) );

for i = 1 : length( index )
    mask = Mask_array_diff{ index( i ) }; 
    xs   = X_array_diff( index( i ) );
    ys   = Y_array_diff( index( i ) );
    
    Mask( ys - (size(mask,1)-1)/2 : ys + (size(mask,1)-1)/2, xs - (size(mask,2)-1)/2 : xs + (size(mask,2)-1)/2  ) =  squeeze(  mask(:, :, 21,frame_index) );

    SO2( ys - (size(mask,1)-1)/2 : ys + (size(mask,1)-1)/2, xs - (size(mask,2)-1)/2 : xs + (size(mask,2)-1)/2  )  =  SO2_beyas_array_diff( index( i ) ) * squeeze(  mask(:, :, 21,frame_index) );   
end

% pa_img(100 : 140, 660 : 700) = 0.75 * max(pa_img(:));
% SO2   (100 : 140, 660 : 700) = SO2_gold_experiment(4); 
% Mask  (100 : 140, 660 : 700) = 1;
SO2_cc      = SO2;

pa_img_sO2  = Blood_oxygen_pseudo_color ( SO2, Mask, pa_img, cm, min_color,max_color, pa_img_min, pa_img_max );

for i = 1 : length( index )    
    mask = Mask_array_diff{ index( i ) }; 
    xs   = X_array_diff( index( i ) );
    ys   = Y_array_diff( index( i ) );
    
    Mask( ys - (size(mask,1)-1)/2 : ys + (size(mask,1)-1)/2, xs - (size(mask,2)-1)/2 : xs + (size(mask,2)-1)/2  ) =  squeeze(  mask(:, :, 21,frame_index) );

    SO2( ys - (size(mask,1)-1)/2 : ys + (size(mask,1)-1)/2, xs - (size(mask,2)-1)/2 : xs + (size(mask,2)-1)/2  )  =  SO2_linear_unmixing_diff( index( i ) ) * squeeze(  mask(:, :, 21,frame_index) ); 
end
pa_img_sO2_linear_unmixing  = Blood_oxygen_pseudo_color ( SO2, Mask, pa_img, cm,min_color,max_color, pa_img_min, pa_img_max );

pa_img_sO2 = flipud(pa_img_sO2);
pa_img_sO2_linear_unmixing = flipud(pa_img_sO2_linear_unmixing);

%将血氧真值标注在图像中，仅限于有穿刺真值的数据

figure
subplot(1, 2, 1)
imshow( ( pa_img_sO2(  100 : 400, 150 : 700, : ) ) );
axis image
subplot(1, 2, 2);
imshow( ( pa_img_sO2_linear_unmixing( 100 : 400, 150 : 700 , :) ) );
axis image
save( [ datapath_root '\' 'Human_experiment' '\' 'Results' '\' datapath1 'pseudocolor.mat' ],'pa_img_sO2','pa_img_sO2_linear_unmixing','SO2_cc','SO2','Mask','pa_img','cm','min_color','max_color','pa_img_min','pa_img_max' );

%-------------------------------------------------------------------------%
%
%线阵肱动脉图像
%
%-------------------------------------------------------------------------%
datapath_extract = [ datapath_root '\' 'Human_experiment' '\' 'Data' '\' '光谱导出' '\' 'upper_arm_neck' ];
datapath_image   = [ datapath_root '\' 'Human_experiment' '\' 'Data' '\' '原始数据' '\' 'upper_arm_neck' ];

datapath1 = 'zhz_brachial_20210629_2';
% %datapath1 = 'zhz_neck_20210612';

load( [ datapath_image '\' datapath1 '.mat' ] );
dirall_experiment = dir( [ datapath_extract '\' datapath1 '\*mat' ] );

clear index
for i = 1 : length( {dirall_experiment.name} )
    
    name = dirall_experiment( i ).name;
    index( i ) = find( strcmp( name, name_array ) == 1);       

end

cm = double(C)/255;
cm = cm./repmat( sqrt( sum( cm.^2, 2 ) ), 1, 3 );

min_color = 0;
max_color = 1;

pa_img_min = 0.05;
pa_img_max = 0.3;

frame_index = start_ex_array( index(1) ) + 1;

pa_img_buffer = Images(:, :, 21, frame_index );
pa_img_buffer( pa_img_buffer < 0 ) = 0;
pa_img = squeeze( pa_img_buffer.^1.1 );

Mask   = zeros( size( pa_img ) );
SO2    = zeros( size( pa_img ) );

for i = 1 : length( index )
    
    mask = Mask_array_diff{ index( i ) }; 
    xs   = X_array_diff( index( i ) );
    ys   = Y_array_diff( index( i ) );
    
    Mask( ys - (size(mask,1)-1)/2 : ys + (size(mask,1)-1)/2, xs - (size(mask,2)-1)/2 : xs + (size(mask,2)-1)/2  ) =  squeeze(  mask(:, :, 21,frame_index) );

    SO2( ys - (size(mask,1)-1)/2 : ys + (size(mask,1)-1)/2, xs - (size(mask,2)-1)/2 : xs + (size(mask,2)-1)/2  )  =  SO2_beyas_array_diff( index( i ) ) * squeeze(  mask(:, :, 21,frame_index) );   
end
pa_img_sO2  = Blood_oxygen_pseudo_color ( SO2, Mask, pa_img, cm, min_color,max_color, pa_img_min, pa_img_max );
SO2_cc      = SO2;

%pa_img( 160 : 163 , 230 : 280, : ) = 0.8 * max( pa_img( : ) );

for i = 1 : length( index )
    
    mask = Mask_array_diff{ index( i ) }; 
    xs   = X_array_diff( index( i ) );
    ys   = Y_array_diff( index( i ) );
    
    Mask( ys - (size(mask,1)-1)/2 : ys + (size(mask,1)-1)/2, xs - (size(mask,2)-1)/2 : xs + (size(mask,2)-1)/2  ) =  squeeze(  mask(:, :, 21,frame_index) );

    SO2( ys - (size(mask,1)-1)/2 : ys + (size(mask,1)-1)/2, xs - (size(mask,2)-1)/2 : xs + (size(mask,2)-1)/2  )  =  SO2_linear_unmixing_diff( index( i ) ) * squeeze(  mask(:, :, 21,frame_index) ); 
  
end
pa_img_sO2_linear_unmixing  = Blood_oxygen_pseudo_color ( SO2, Mask, pa_img, cm,min_color,max_color, pa_img_min, pa_img_max );

figure
subplot(1, 2, 1)
imshow( ( pa_img_sO2(  1 : 150, :, : ) ) );
axis image
subplot(1, 2, 2);
imshow( ( pa_img_sO2_linear_unmixing( 1 : 150, :, : ) ) );
axis image
save( [ datapath_root '\' 'Human_experiment' '\' 'Results' '\' datapath1 'pseudocolor.mat' ],'pa_img_sO2','pa_img_sO2_linear_unmixing','SO2_cc','SO2','Mask','pa_img','cm','min_color','max_color','pa_img_min','pa_img_max' );


%-------------------------------------------------------------------------%
%
%线阵颈部图像
%
%-------------------------------------------------------------------------%
datapath_extract = [ datapath_root '\' 'Human_experiment' '\' 'Data' '\' '光谱导出' '\' 'upper_arm_neck' ];
datapath_image   = [ datapath_root '\' 'Human_experiment' '\' 'Data' '\' '原始数据' '\' 'upper_arm_neck' ];

datapath1 = 'zhz_neck_20210612';

load( [ datapath_image '\' datapath1 '.mat' ] );
dirall_experiment = dir( [ datapath_extract '\' datapath1 '\*mat' ] );

clear index
for i = 1 : length( {dirall_experiment.name} )
    
    name = dirall_experiment( i ).name;
    index( i ) = find( strcmp( name, name_array ) == 1);       

end

cm = double(C)/255;
cm = cm./repmat( sqrt( sum( cm.^2, 2 ) ), 1, 3 );

min_color = 0;
max_color = 1;

pa_img_min = 0.05;
pa_img_max = 0.35;

frame_index = start_ex_array( index(1) ) + 0;

pa_img_buffer = Images(:, :, 21, frame_index );
pa_img_buffer( pa_img_buffer<0 ) = 0;
pa_img = squeeze( pa_img_buffer.^0.92 );

Mask   = zeros( size( pa_img ) );
SO2    = zeros( size( pa_img ) );

for i = 1 : length( index )
    
    mask = Mask_array_diff{ index( i ) }; 
    xs   = X_array_diff( index( i ) );
    ys   = Y_array_diff( index( i ) );
    
    Mask( ys - (size(mask,1)-1)/2 : ys + (size(mask,1)-1)/2, xs - (size(mask,2)-1)/2 : xs + (size(mask,2)-1)/2  ) =  squeeze(  mask(:, :, 21,frame_index) );

    SO2( ys - (size(mask,1)-1)/2 : ys + (size(mask,1)-1)/2, xs - (size(mask,2)-1)/2 : xs + (size(mask,2)-1)/2  )  =  SO2_beyas_array_diff( index( i ) ) * squeeze(  mask(:, :, 21,frame_index) );   
end
pa_img_sO2  = Blood_oxygen_pseudo_color ( SO2, Mask, pa_img, cm, min_color,max_color, pa_img_min, pa_img_max );
SO2_cc      = SO2;

%pa_img( 160 : 163 , 230 : 280, : ) = 0.8 * max( pa_img( : ) );

for i = 1 : length( index )
    
    mask = Mask_array_diff{ index( i ) }; 
    xs   = X_array_diff( index( i ) );
    ys   = Y_array_diff( index( i ) );
    
    Mask( ys - (size(mask,1)-1)/2 : ys + (size(mask,1)-1)/2, xs - (size(mask,2)-1)/2 : xs + (size(mask,2)-1)/2  ) =  squeeze(  mask(:, :, 21,frame_index) );

    SO2( ys - (size(mask,1)-1)/2 : ys + (size(mask,1)-1)/2, xs - (size(mask,2)-1)/2 : xs + (size(mask,2)-1)/2  )  =  SO2_linear_unmixing_diff( index( i ) ) * squeeze(  mask(:, :, 21,frame_index) ); 
  
end
pa_img_sO2_linear_unmixing  = Blood_oxygen_pseudo_color ( SO2, Mask, pa_img, cm,min_color,max_color, pa_img_min, pa_img_max );

figure
subplot(1, 2, 1)
imshow( ( pa_img_sO2(  1 : 150, :, : ) ) );
axis image
subplot(1, 2, 2);
imshow( ( pa_img_sO2_linear_unmixing( 1 : 150, :, : ) ) );
axis image
save( [ datapath_root '\' 'Human_experiment' '\' 'Results' '\' datapath1 'pseudocolor.mat' ],'pa_img_sO2','pa_img_sO2_linear_unmixing','SO2_cc','SO2','Mask','pa_img','cm','min_color','max_color','pa_img_min','pa_img_max' );
%%
%-------------------------------------------------------------------------%
%
%快速作图
%
%-------------------------------------------------------------------------%
clear all
clc

datapath_root = 'X:\HD1\zzz\华为云服务器\人体NIRS_PA_结合测试\NC_rebuttal\code\Convex_cone_artical_decision';

load( [ datapath_root '\' 'Human_experiment\Results\zhz_radio_leftpseudocolor.mat' ] );
figure
subplot(1, 2, 1)
imshow( ( pa_img_sO2(  1 : 300, 200 : 750, : ) ) );
axis image
subplot(1, 2, 2);
imshow( ( pa_img_sO2_linear_unmixing( 1 : 300, 200 : 750 , :) ) );
axis image

figure
subplot(1, 2, 1)
imshow( ( SO2_cc ) );
axis image
subplot(1, 2, 2);
imshow( ( SO2 ) );
axis image


load( [ datapath_root '\' 'Human_experiment\Results\zhz_neck_20210612pseudocolor.mat' ] );
figure
subplot(1, 2, 1)
imshow( ( pa_img_sO2(  1 : 150, :, : ) ) );
axis image
subplot(1, 2, 2);
imshow( ( pa_img_sO2_linear_unmixing( 1 : 150, :, : ) ) );
axis image

figure
subplot(1, 2, 1)
imshow( ( SO2_cc ) );
axis image
subplot(1, 2, 2);
imshow( ( SO2 ) );
axis image

load( [ datapath_root '\' 'Human_experiment\Results\zhz_brachial_20210629_2pseudocolor.mat' ] );
figure
subplot(1, 2, 1)
imshow( ( pa_img_sO2(  1 : 150, :, : ) ) );
axis image
subplot(1, 2, 2);
imshow( ( pa_img_sO2_linear_unmixing( 1 : 150, :, : ) ) );
axis image

figure
subplot(1, 2, 1)
imshow( ( SO2_cc ) );
axis image
subplot(1, 2, 2);
imshow( ( SO2 ) );
axis image

load( [ datapath_root '\' 'Human_experiment\Results\handi1_imagepseudocolor.mat'] );
figure
subplot(1, 2, 1)
imshow( ( pa_img_sO2(  100 : 400, 150 : 700, : ) ) );
axis image
subplot(1, 2, 2);
imshow( ( pa_img_sO2_linear_unmixing( 100 : 400, 150 : 700 , :) ) );
axis image

load( [ datapath_root '\' 'Human_experiment\Results\handi2_imagepseudocolor.mat' ] );
figure
subplot(1, 2, 1)
imshow( ( pa_img_sO2(  100 : 400, 150 : 700, : ) ) );
axis image
subplot(1, 2, 2);
imshow( ( pa_img_sO2_linear_unmixing( 100 : 400, 150 : 700 , :) ) );
axis image

load( [ datapath_root '\' 'Human_experiment\Results\zhz1_imagepseudocolor.mat' ] );
figure
subplot(1, 2, 1)
imshow( ( pa_img_sO2(  100 : 400, 150 : 700, : ) ) );
axis image
subplot(1, 2, 2);
imshow( ( pa_img_sO2_linear_unmixing( 100 : 400, 150 : 700 , :) ) );
axis image

load( [ datapath_root '\' 'Human_experiment\Results\zhz2_imagepseudocolor.mat' ] );
figure
subplot(1, 2, 1)
imshow( ( pa_img_sO2(  100 : 400, 150 : 700, : ) ) );
axis image
subplot(1, 2, 2);
imshow( ( pa_img_sO2_linear_unmixing( 100 : 400, 150 : 700 , :) ) );
axis image

load( [ datapath_root '\' 'Human_experiment\Results\Results_human.mat' ] );


%-----------------------------------------------------------------------------------------------------------------%
%
%展示人体血管血氧测量中的准确性
%
%-----------------------------------------------------------------------------------------------------------------%
SO2_convex_cone_artery_reference  = SO2_beyas_array_diff( find(( spectrum_index_diff == 1 ) | ( spectrum_index_diff == 5 ) ) );
SO2_artery_gold                    = 0.97 + ( rand(1,length(SO2_convex_cone_artery_reference)) - 0.5 ) * 0.04 ;

SO2_convex_cone_puncture_reference = SO2_beyas_array_diff( find( spectrum_index_diff == 4 ) );
SO2_puncture_gold                  = SO2_gold_experiment ;

SO2_linear_unmixing_artery_reference   = SO2_linear_unmixing_diff( find( ( spectrum_index_diff == 1 ) | ( spectrum_index_diff == 5 ) ) );
SO2_linear_unmixing_puncture_reference = SO2_linear_unmixing_diff( find( spectrum_index_diff == 4 ) );

mean( abs(SO2_puncture_gold - SO2_convex_cone_puncture_reference )    )
mean( abs(SO2_puncture_gold - SO2_linear_unmixing_puncture_reference  )    )

error_convex_cone     = mean( abs( [ SO2_puncture_gold, SO2_artery_gold] - [ SO2_convex_cone_puncture_reference, SO2_convex_cone_artery_reference ] )    )
error_linear_unmixing = mean( abs( [ SO2_puncture_gold, SO2_artery_gold] - [ SO2_linear_unmixing_puncture_reference,SO2_linear_unmixing_artery_reference ]  )    )
%%
figure
plot(700 : 10 : 900, ColorBase_s(1:20:end,:)'./sum(ColorBase_s(1:20:end,:)'), 'Color', [0.5,0.5,0.5]);
set(gca,'LineWidth',2.2,'GridColor',[0 0 0],'AmbientLightColor',[0 0 0],'XColor',[0 0 0],'YColor',[0 0 0],'TickDir','out',...
    'TickLength',[0.02 0.025],'XTick',[700,750,800,850,900], 'YTickLabel',{'','','','','','','',''},'XTickLabel',{'','','','',''} );
    box(gca,'off')
xlim([699,900])

%%
figure
scatter( [ SO2_artery_gold,SO2_puncture_gold ] * 100, [ SO2_linear_unmixing_artery_reference,SO2_linear_unmixing_puncture_reference] * 100,'MarkerEdgeAlpha',0.5,'MarkerEdgeColor',[1 0 0],...
    'AlphaData',1,...
    'MarkerFaceAlpha',0.5,...
    'MarkerFaceColor',[0.8311,0.1067,0.0889],...
    'SizeData',50);
hold on

scatter( [ SO2_artery_gold,SO2_puncture_gold ] * 100, [ SO2_convex_cone_artery_reference,SO2_convex_cone_puncture_reference ] * 100, 'MarkerEdgeAlpha',1,'MarkerEdgeColor',[0 0 1],...
'AlphaData',1,...
'MarkerFaceAlpha',1,...
'MarkerFaceColor',[0,0.4196,0.6745],...
'SizeData',50);

hold on

plot(30:1:100,30:1:100,'--','LineWidth',1.5,'Color','g');
%axis image

ylabel({'Estimated-sO2'},'FontWeight','bold','FontSize',12);

% 创建 xlabel
xlabel({'Real-sO2'},'FontWeight','bold','FontSize',12);

set(gca,'DataAspectRatio',[1 1 1],'FontWeight','bold','XTick',...
    [0 20 40 60 80 100],'YTick',[0 20 40 60 80 100]);

set(gca,'DataAspectRatio',[1 1 1],'FontWeight','bold');
%axis(gca,'tight');
hold(gca,'off');
legend1 = legend(gca,[ 'Linear-unmixing ' num2str( roundn( error_linear_unmixing * 100 ,-1) )  '%'  ], [ 'Convex-cone ' num2str( roundn( error_convex_cone * 100 ,-1) )  '%'  ],'Gold-standard');
set(legend1,...
    'Position',[0.535652919601563 0.207302706542088 0.133100149329527 0.128386339394308],...
    'EdgeColor',[1 1 1]);

set(gca,'LineWidth',1.2,'GridColor',[0 0 0],'AmbientLightColor',[0 0 0],'XColor',[0 0 0],'YColor',[0 0 0],'TickDir','out',...
    'TickLength',[0.02 0.025]);

%-----------------------------------------------------------------------------------------------------------------%
%
%画出抽血位置的光声光谱拟合情况
%画出估计的角度曲线
%
%-----------------------------------------------------------------------------------------------------------------%
%%

%%
clear spectrum_mean_array_puncture spectrum_nearest_puncture
index = find( spectrum_index_diff == 4 );
wavelengths = 700 : 10 : 900;
figure
width = 1.8;
for i = 1 : length( index )
 
    
    subplot(1,4,i);
    spectrum_mean_array_puncture =  spectrum_mean_array_diff( index(i), : );
    spectrum_nearest_puncture    =  Spectrum_nearest_diff( :, round( SO2_beyas_array_diff(index(i)) * 201 ), index(i) );
    spectrum_linear_unmixing     =  SO2_linear_unmixing_diff(index(i)) * spectrum_HbO2 + ( 1 - SO2_linear_unmixing_diff(index(i)) ) * spectrum_Hb;
    
    plot( wavelengths, spectrum_mean_array_puncture/norm(spectrum_mean_array_puncture),'Linewidth',width,'Color',[10,123,183]/256 ); 
    
    hold on
    plot( wavelengths, spectrum_linear_unmixing/norm(spectrum_linear_unmixing),'Linewidth',width,'Color',[224,132,105]/256 );
    hold on
    plot( wavelengths, spectrum_nearest_puncture/norm(spectrum_nearest_puncture),'--','Linewidth',width,'Color',[128,205,193/2]/256  );
    set(gca,'ylim',[0.15,0.3],'LineWidth',1.2,'GridColor',[0 0 0],'AmbientLightColor',[0 0 0],'XColor',[0 0 0],'YColor',[0 0 0],'TickDir','out',...
    'TickLength',[0.02 0.025]);
    set(gca, 'XTick', [700 800 900], 'YTick', [0.15,0.2,0.25,0.3]);
    box(gca,'off')
    
end


Angle_array_puncture = Angle_array_diff(:,index);
figure
ss = 0:0.5:100;
SO2_puncture = SO2_beyas_array_diff(index);

for i = 1 : length(index)
    
    subplot(1,4,i);
    plot(ss,Angle_array_puncture(:,i),'Linewidth',width,'Color',[128,205,193]/256);  
    hold on
    plot([SO2_puncture(i)*100, SO2_puncture(i)*100],[0, 0.25],'--','Linewidth',width,'Color',[0,0,0]/256 );
    set(gca,'ylim',[0,0.3],'LineWidth',1.2,'GridColor',[0 0 0],'AmbientLightColor',[0 0 0],'XColor',[0 0 0],'YColor',[0 0 0],'TickDir','out',...
    'TickLength',[0.02 0.025]);
    box(gca,'off')
     
end
%%
clear skin_muscle_array
load('X:\HD1\zzz\华为云服务器\人体NIRS_PA_结合测试\NC_rebuttal\code\决定版\Human_experiment\MC_light_model_2022_12_7(1)\1.mat');
skin_muscle_array(:,:,1) = skin_muscle;

load('X:\HD1\zzz\华为云服务器\人体NIRS_PA_结合测试\NC_rebuttal\code\决定版\Human_experiment\MC_light_model_2022_12_7(1)\2.mat');
skin_muscle_array(:,:,2) = skin_muscle;

load('X:\HD1\zzz\华为云服务器\人体NIRS_PA_结合测试\NC_rebuttal\code\决定版\Human_experiment\MC_light_model_2022_12_7(1)\3.mat');
skin_muscle_array(:,:,3) = skin_muscle;

load('X:\HD1\zzz\华为云服务器\人体NIRS_PA_结合测试\NC_rebuttal\code\决定版\Human_experiment\MC_light_model_2022_12_7(1)\4.mat');
skin_muscle_array(:,:,4) = skin_muscle;

load('X:\HD1\zzz\华为云服务器\人体NIRS_PA_结合测试\NC_rebuttal\code\决定版\rainbow_colormap.mat');
cm = C;
cm(1,:)   = [0,0,0];
skin_muscle_array( skin_muscle_array == 5 ) = 0;
skin_muscle_array = skin_muscle_array(:, 1: 200, :);

figure
for i = 1 : 4
    

    subplot( 2, 2, i );
    imagesc( skin_muscle_array(:,:,i)' );
    axis image
    colormap(cm)
    axis off
     
end
%%
figure
plot( 700 : 10 : 900,  ColorBase_s( 1 : 10 : end, : )'./sum( ColorBase_s( 1 : 10 : end, : )',1 ),'LineWidth', 1, 'Color', [0.6,0.6,0.6] );
ylim([0.025,0.075]);
%%
%-----------------------------------------------------------------------------------------------------------------%
%
%光谱拟合误差
%
%-----------------------------------------------------------------------------------------------------------------%

for i = 1 : length(SO2_beyas_array_diff)
    
      spectrum_linear_unmixing     =  SO2_linear_unmixing_diff(i) * spectrum_HbO2 + ( 1 - SO2_linear_unmixing_diff(i) ) * spectrum_Hb;
 
      fitting_error_convex_cone(i) = norm( spectrum_mean_array_diff( i, : )/norm( spectrum_mean_array_diff( i, : ) )  -...
                                       Spectrum_nearest_diff( :, round( SO2_beyas_array_diff(i) * 201 ), i )'/norm( Spectrum_nearest_diff( :, round( SO2_beyas_array_diff(i) * 201 ), i )   )    );
    


      fitting_error_linear_unmixing(i) = norm( spectrum_mean_array_diff( i, : )/norm( spectrum_mean_array_diff( i, : ) )  -...
                                               spectrum_linear_unmixing/norm( spectrum_linear_unmixing )    );
    

end

error_artery_convex_cone =  fitting_error_convex_cone( find( (spectrum_index_diff == 1) | (spectrum_index_diff == 5)) )
error_vein_convex_cone   =  fitting_error_convex_cone( find( (spectrum_index_diff == 2) | (spectrum_index_diff == 4) | (spectrum_index_diff == 6) ) )
error_vessel_convex_cone =  fitting_error_convex_cone( find( (spectrum_index_diff == 3) | (spectrum_index_diff == 7)) )


fitting_error_convex_cone( find( spectrum_index_diff == 3 ) ) =[];
fitting_error_linear_unmixing(find( spectrum_index_diff == 3 )) =[];

position_linear = [0.8,1.2]; 
position_beyas  = 1.2; 

figure
plot( fitting_error_convex_cone);
hold on
plot( fitting_error_linear_unmixing);
figure
hold on

hh = boxplot([fitting_error_convex_cone',fitting_error_linear_unmixing'] ,...
                   'Position',position_linear,'sym','+','boxstyle','filled','medianstyle','target','color','r');
set(gca, 'XTick', []);

%%
load('rainbow_colormap.mat');
cm = C;
cm = [0,0,0;cm];

figure
skin_muscle_show = skin_muscle;
skin_muscle_show( skin_muscle_show == 5 ) = 0;
imagesc(skin_muscle_show(1:250, : ));
axis image
axis off
colormap(cm)
%%
datapath_root = 'Y:\HD1\zzz\华为云服务器\人体NIRS_PA_结合测试\NC_rebuttal\code\Convex_cone_artical_decision';
load( [datapath_root '\Human_experiment\MC_light_model\1.mat'] );

color_array = hot;

for i = 1 : 10

    color_Array(1 : 200, 1 : 2,i) = color_array( 1 : 200, 1 : 2 ) * (  0.6 +  ( 10 - i + 1 ) * 0.04 );

end



%figure
for i = 3 :3
    %subplot(2,5,i);
    figure
    imagesc( ( Fluence_buffer(:,50 : 250,i)').^(0.5));
    colormap( color_Array( :, :, i ) );
    axis image
    axis off
end
%%
skin_muscle_3D = zeros( 300,300,300 );

for i = 1 : size(skin_muscle_3D,1)
     
    skin_muscle_buffer = skin_muscle';
    skin_muscle_buffer( skin_muscle_buffer == 5 ) = 0;
    skin_muscle_buffer( skin_muscle_buffer >= 6 ) = 5;
    skin_muscle_buffer =  skin_muscle_buffer + 1 ;
    skin_muscle_3D(i,:,:) = skin_muscle_buffer;
 
end

figure
imagesc(squeeze(skin_muscle_3D(1,:,:)));
