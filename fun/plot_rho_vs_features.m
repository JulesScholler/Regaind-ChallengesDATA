function plot_rho_vs_features(rho,features)

bar(rho,'FaceColor',[255 102 102]/255,'EdgeColor','k','Linewidth',1.5)
set(gca,'XTickLabel',features,'XTickLabelRotation',90,'FontSize',14)
ylabel 'Spearman''s \rho' 

end