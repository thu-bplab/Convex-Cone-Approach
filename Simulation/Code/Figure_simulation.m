clc
clear all

% load( ['Simulation' '\' 'Results' '\' 'Results.mat' ] );            % Rectangular_phantom
load( ['Simulation' '\' 'Results' '\' 'Results_circle.mat' ] );      % Circle_phantom
%%
sample_num = 180;
SO2_bayes_SNR = zeros( sample_num, length(SO2_bayes_array) / sample_num );

for i = 1 : 5
    
    if i == 1
        SO2_bayes_SNR(:,i)       = SO2_array ( ( i - 1 ) * sample_num + 1 : i * sample_num  )';
    else
        SO2_bayes_SNR(:,i)       = SO2_bayes_array ( ( i - 1 ) * sample_num + 1 : i * sample_num  )';
    end
    
    SO2_convex_cone_SNR(:,i)     = SO2_array       ( ( i - 1 ) * sample_num + 1 : i * sample_num  )';
    SO2_linear_SNR(:,i)          = SO2_linear_array( ( i - 1 ) * sample_num + 1 : i * sample_num  )';
    SO2_gold_SNR(:,i)            = SO2_gold        ( ( i - 1 ) * sample_num + 1 : i * sample_num  )';
    
    
end    


SO2_beyas_error           = abs( SO2_bayes_SNR - SO2_gold_SNR );
SO2_linear_unmixing_error = abs( SO2_linear_SNR - SO2_gold_SNR );

%%
k = 5;

figure
scatter(SO2_gold_SNR(:, k) * 100,SO2_linear_SNR(:, k) * 100,'MarkerEdgeAlpha',0.5,'MarkerEdgeColor',[1 0 0],...
    'AlphaData',1,...
    'MarkerFaceAlpha',0.5,...
    'MarkerFaceColor',[0.8311,0.1067,0.0889],...
    'SizeData',15);
hold on

scatter(SO2_gold_SNR(:, k) * 100, SO2_bayes_SNR(:, k) * 100, 'MarkerEdgeAlpha',1,'MarkerEdgeColor',[0 0 1],...
'AlphaData',1,...
'MarkerFaceAlpha',1,...
'MarkerFaceColor',[0,0.4196,0.6745],...
'SizeData',15);


plot(0:1:100,0:1:100,'--','LineWidth',1.5,'Color','g');
axis image

ylabel({'test-sO2'},'FontWeight','bold','FontSize',12);

xlabel({'gold-sO2'},'FontWeight','bold','FontSize',12);

set(gca,'DataAspectRatio',[1 1 1],'FontWeight','bold','XTick',...
    [0 20 40 60 80 100],'YTick',[0 20 40 60 80 100]);

set(gca,'DataAspectRatio',[1 1 1],'FontWeight','bold');
axis(gca,'tight');
hold(gca,'off');
legend1 = legend(gca,'Linear-unmixing','Convex-cone','Gold-standard');
set(legend1,...
    'Position',[0.535652919601563 0.207302706542088 0.133100149329527 0.128386339394308],...
    'EdgeColor',[1 1 1]);
