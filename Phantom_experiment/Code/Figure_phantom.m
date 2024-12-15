%%
%show the fitting result
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
%----------------------------------------------------------------------------------------------%
%
%show the estimation result
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

ylabel({'test-sO2'},'FontWeight','bold','FontSize',12);

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

