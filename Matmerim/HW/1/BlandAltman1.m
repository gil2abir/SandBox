function [ diff_mean, SD, CI ] = BlandAltman1( data1,data2 )

diff_vec=data1-data2;

mean_vec=(data1+data2)./2;

corr_coef=corr(diff_vec,mean_vec);

disp(['correlation=',num2str(corr_coef)])

if corr_coef>0.8

error('Statistical dependency between differnces to expected values');

else

disp('No statistical dependency between differnces to expected values');

end

diff_mean=mean(diff_vec);

SD=std(diff_vec);

CI=[diff_mean+2*SD, diff_mean-2*SD];

plot(mean_vec,diff_vec,'wo','MarkerFaceColor',[0 0.45,0.75],'MarkerEdgeColor',[0 0 1],'MarkerSize',12);

set(gca,'FontWeight','bold','FontSize',16)

set(gca,'YTickLabel',num2str(get(gca,'YTick').'))

hold on

plot([min(mean_vec),max(mean_vec)],[diff_mean

diff_mean],'b','LineWidth',3)

hold on

plot([min(mean_vec),max(mean_vec)],[CI(1) CI(1)],'r','LineWidth',3,'LineStyle','--')

hold on

plot([min(mean_vec),max(mean_vec)],[CI(2) CI(2)],'r','LineWidth',3,'LineStyle','--')

hold on

xlabel('Average')

ylabel('Differences')

title('Bland-Altman agreement test')