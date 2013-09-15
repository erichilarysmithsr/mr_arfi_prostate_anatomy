% mr_arfi_path_axes.m
%
% Generate plots of the axis-ratios for MR, ARFI and pathology.
%
% Mark Palmeri
% mlp6@duke.edu
% 2013-09-14

data = csvread('../data/Prostate_CZ_PZ_Volume_Axis_Measurements.csv');

Pnum = num2cell(data(:,1));

% ordering the axes as:
% (1) APEX-TO-BASE (axial)
% (2) LATERAL-TO-LATERAL (lat)
% (3) ANTERIOR-TO-POSTERIOR (elev)
MRaxes = [data(:,IAMHERE];
ARFIaxes = [arfi_cz_vol, arfi_pz_vol];
PATHaxes

% fontsize
fs = 18;
bar_width = 0.3;

figure;
hold on;
h=bar([1:length(MRdataStack)],MRdataStack,bar_width,'stacked');
g=bar([1:length(ARFIdataStack)]+bar_width,ARFIdataStack,bar_width,'stacked');
set(h(1),'FaceColor',[0 0 1]);
set(h(2),'FaceColor',[1 0 0]);
set(g(1),'FaceColor',[0 1 0]);
set(g(2),'FaceColor',[1 1 0]);
ylabel('Zone Volumes (cm^3)','FontSize',fs)
xlabel('Study Subject','FontSize',fs);
title('MR (Red/Blue) and ARFI (Yellow/Green) Zone Volumes','FontSize',fs);
a=axis;
a(2) = 17;
axis(a);
legend('Central Gland','Peripheral Zone','Location','NorthWest');
legend boxoff;
%set(gca,'XTickLabel',Pcell)

set(gca, ...
    'Box'         , 'off'     , ...
    'TickDir'     , 'out'     , ...
    'TickLength'  , [.01 .01] , ...
    'XMinorTick'  , 'off'      , ...
    'YMinorTick'  , 'off'      , ...
    'XGrid'       , 'off'      , ...
    'XColor'      , [0 0 0], ...
    'YColor'      , [0 0 0], ...
    'XMinorGrid'  , 'off'      , ...
    'LineWidth'   , 2, ...
    'FontSize'    , fs);

print('-depsc2','mr_arfi_volumes.eps');
close;

% lets do a little more processing to figure out what is going on... first the
% relative volume in ARFI relative to MR

arfi_mr_vol_diff = ((arfi_total_vol./mr_total_vol) - 1)*100;
figure;
bar([1:length(MRdataStack)],arfi_mr_vol_diff,0.5);
title('ARFI:MR Total Volume Comparison','FontSize',fs);
xlabel('Study Subject','FontSize',fs);
ylabel('Percent Difference','FontSize',fs);
set(gca,'FontSize',fs);
a=axis;
a(2) = 17;
a(3) = -5;
a(4) = 110;
axis(a);
text(0.5,100,sprintf('Mean Diff = %.1f +/- %.1f',mean(arfi_mr_vol_diff),std(arfi_mr_vol_diff)),'FontSize',fs);
print('-depsc2','mr_arfi_volume_diff.eps');
close;

% now lets look at the relative ratios of CG:total volume for each modality
mr_cg_total = (mr_cg_vol./mr_total_vol)*100;
arfi_cz_total = (arfi_cz_vol./arfi_total_vol)*100;

figure;
hold on;
h=bar([1:length(MRdataStack)],mr_cg_total,bar_width);
set(h(1),'FaceColor',[0 0 1]);
g=bar([1:length(ARFIdataStack)]+bar_width,arfi_cz_total,bar_width);
set(g(1),'FaceColor',[0 1 0]);
xlabel('Study Subject','FontSize',fs);
ylabel('Ratio of Central : Total Volume','FontSize',fs);
title('MR and ARFI Central : Total Ratios','FontSize',fs);
set(gca,'FontSize',fs);
a = axis;
a(2) = 17;
a(4) = 100;
axis(a);

text(1,90,sprintf('Mean Diff = %.1f +/- %.1f',mean(arfi_cz_total-mr_cg_total),std(arfi_cz_total-mr_cg_total)),'FontSize',fs);

print('-depsc2','mr_arfi_path_axes.eps');
close;
