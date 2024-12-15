%%
clear all
addpath('Toolbox');

%Load colorbase
load( ['Simulation\MC_light_model\ColorBase_s\' 'ColorBase_s' ] );
load( ['Substance_spectra\spectrum_Hb_Cope.mat' ] );
load( ['Substance_spectra\spectrum_HbO2_Cope.mat' ] );

%Load testdata Rectangular_phantom or Circle_phantom
datapath_1 = ['Simulation' '\' 'Data' '\' 'Rectangular_phantom' ];                 % Rectangular_phantom
%datapath_1 = ['Simulation' '\' 'Data' '\' 'Circle_phantom' ];                       % Circle_phantom

clear PA_spectrum_array Fluence_spectrum SO2_gold Fluence_spectrum_array PA_std_array std_nominal_array

num                    = 0;
num_index              = 0;
SO2_gold               = [];
Fluence_spectrum_array = []; 

noise_std_array = [ 0, 0.01, 0.02, 0.04, 0.08 ];
%noise_std_array = [ 0 ];
radio_array     = [0.2, 0.4, 0.6]; 

for noise_array_index = 1 : length( noise_std_array )

    noise_std       = noise_std_array( noise_array_index );
    dirs = dir([datapath_1,'\*mat']);

    for i = 1 : length(dirs);

        num = num + 1
        load([ datapath_1 '\' dirs(i).name ], 'Fluence_buffer');

        load([ datapath_1 '\' dirs(i).name ], 'Fluence_section');
        load([ datapath_1 '\' dirs(i).name ], 'concentration_3D_section');
        load([ datapath_1 '\' dirs(i).name ], 'SO2_3D_section');

        load([ datapath_1 '\' dirs(i).name ], 'skin_muscle');
        load([ datapath_1 '\' dirs(i).name ], 'vein_index_img');
        load([ datapath_1 '\' dirs(i).name ], 'SO2_vein');

        mm =  repmat( (  ( skin_muscle' == 2 ) | ( skin_muscle' == 3 ) |( skin_muscle' == 4 ) |( skin_muscle' == 6 )   ), [ 1, 1, size( Fluence_section, 4 ) ] );
        
        for wave = 1 : size(Fluence_buffer,3)

            PA_3D_section(:, :, :, wave) = Fluence_section(:,:,:,wave) .* concentration_3D_section .* (  SO2_3D_section * spectrum_HbO2(wave) + ( 1 - SO2_3D_section ) * spectrum_Hb(wave) );

        end

        PA_2D_section        = squeeze( sum( PA_3D_section, 1 ) );
        PA_2D_section_buffer =  PA_2D_section;
        
        for wave = 1 : size(Fluence_buffer,3)

            PA_2D_section(:, :, wave) = PA_2D_section(:, :, wave) + noise_std * mean(  PA_2D_section_buffer( mm == 1 ) ) .* randn( size(PA_2D_section,1), size(PA_2D_section,2) );
            
        end
        
        ee = 20 * log( PA_2D_section_buffer( :, :, : ) / ( noise_std * mean(  PA_2D_section_buffer( mm == 1 ) ) ) ) / log(10);
        std_nominal_array( noise_array_index, i ) = sum(  ee( find( repmat( ( vein_index_img' ~=0 ), [1,1,21] ) ~=0  )  )  ) / length( find( vein_index_img~=0 ) ) / 21;  
        
        PA_2D_mean = mean(PA_2D_section,3);

        for radio_index = 1 : length( radio_array )

             radio = radio_array( radio_index );

             for in = 1 : 4

                num_index = num_index + 1; 
                index = find( vein_index_img' == in  );
                [in_sort,inn] = sort( PA_2D_mean( index ) );

                    for wave = 1 : size( PA_2D_section,3)

                        PA_buffer_2D                             = squeeze(  PA_2D_section(:,:,wave) );
                        PA_spectrum_array(num_index, wave)       = mean( PA_buffer_2D( index( inn( end - round( radio * length(index) ) : end ) ) ) );
                        Fluence_spectrum_array (num_index, wave) = PA_spectrum_array(num_index,wave)./( SO2_vein(in) .*  spectrum_HbO2(wave) + ( 1 - SO2_vein(in) ) .* spectrum_Hb(wave)   );
                        PA_std_array     (num_index, wave)       = noise_std * mean(  PA_2D_section_buffer( mm == 1 ) ) / ( round( radio * length(index) ) + 1 );
                   
                    end
                    
                        SO2_gold         (num_index)             = SO2_vein(in);

             end

        end

    end

end

figure
plot(700 : 10 : 900, ColorBase_s( 1 : 5 : end, : )'./sum(ColorBase_s( 1 : 5 : end, : )',1),'Color',[0.6,0.6,0.6]);
hold on
for i = 1 : size(Fluence_spectrum_array,1)

    plot(700 : 10 : 900, Fluence_spectrum_array(i,:)/sum(Fluence_spectrum_array(i,:)));
    hold on
    
end  

%%
%Fitting the light fluence spectra
clear Angle_Fluence Nearest_Fluence 
for i = 1 : 180
    
    i
    [Angle_Fluence(i), Nearest_Fluence(:,i), ~, ~, ~, ~, ~]...
                                 = angleToConvexCone( Fluence_spectrum_array(i,:)', ColorBase_s' );

end

[~,in] = max(Angle_Fluence)

figure
plot( Fluence_spectrum_array(in,:)' );
hold on
plot( Nearest_Fluence(:,in) );


clear  P_post_array Nearest_PA_array Angle_array SO2_array SO2_bayes_array SO2_linear_array Angle_min;

tic

parfor i = 1 : size( PA_spectrum_array,1)
  
    i
    
    if i <= 180
        [SO2_array(i), Angle, NearestPA, flags] = convexConeSO2...
                            ( PA_spectrum_array(i,:), spectrum_Hb, spectrum_HbO2, ColorBase_s);
        SO2_bayes_array(i) = 0;
        P_post             = zeros(1,201);
        
    else
        
        [SO2_array(i), Angle, Angle_level, NearestPA, flags] = convexConeSO2_noise...
                            ( PA_spectrum_array(i,:), spectrum_Hb, spectrum_HbO2, ColorBase_s, PA_std_array(i,:) );
        
        [SO2_bayes_array(i), P_post] = convexConeSO2_bayes( PA_spectrum_array(i,:), Angle, PA_std_array(i,:) );
        

    end
    
    P_post_array{i}     = P_post;
    Nearest_PA_array{i} = NearestPA;
    Angle_array{i}      = Angle;
    Angle_min  (i)      = min(Angle);   
    
    SO2_linear_array(i) = linearUnmixing( PA_spectrum_array(i,:), spectrum_HbO2, spectrum_Hb );
    
end

toc

save( ['Simulation' '\' 'Results' '\' 'Results.mat' ] );       % Rectangular_phantom
%save( ['Simulation' '\' 'Results' '\' 'Results_circle.mat' ] );    % Circle_phantom


mean( abs( SO2_gold - SO2_array ) )
mean( abs( SO2_gold - SO2_bayes_array  ) )
mean( abs( SO2_gold - SO2_linear_array ) )

figure
scatter( SO2_gold,SO2_array);                               
hold on
scatter( SO2_gold,SO2_bayes_array);
hold on
scatter( SO2_gold,SO2_linear_array);

hold on
plot([0,1],[0,1]);
axis image


in = randperm( size( PA_spectrum_array, 1 ) , 25);

figure
for i = 1 : length(in)

    subplot(5,5,i);
    plot( PA_spectrum_array( in(i), : ));
    hold on
    plot( PA_spectrum_array( in(i), : ) -  PA_std_array( in(i), : ), '--' );
    hold on
    plot( PA_spectrum_array( in(i), : ) +  PA_std_array( in(i), : ), '--' );

end


