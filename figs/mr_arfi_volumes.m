% bar_stacked_volumes.m
%
% Generate stacked bar graphs comparing the central and total prostate volumes
% in MR and ARFI images.  Data are loaded in from the CSV file exported from
% Tyler's Google spreadsheet.
%
% Mark Palmeri
% mlp6@duke.edu
% 2013-09-13

vols = csvread('../data/Prostate_CZ_PZ_Volume_Axis_Measurements.csv');

mr_cg_vol = vols(:,2);
mr_total_vol = vols(:,3);
mr_pz_vol = mr_total_vol - mr_cg_vol;
arfi_cz_vol = vols(:,10);
arfi_total_vol = vols(:,11);
arfi_pz_vol = arfi_total_vol - arfi_cz_vol;

MRdataStack = [mr_cg_vol, mr_pz_vol];
ARFIdataStack = [arfi_cz_vol, arfi_pz_vol];
% convert from mm^3 -> cm^3
MRdataStack = MRdataStack/1e3;
ARFIdataStack = ARFIdataStack/1e3;

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
colormap(winter)
ylabel('Zone Volumes (cm^3)','FontSize',fs)
xlabel('Study Subject','FontSize',fs);
title('MR (Red/Blue) and ARFI (Yellow/Green) Zone Volumes','FontSize',fs);
a=axis;
a(2) = 17;
axis(a);
legend('Central Gland','Peripheral Zone','Location','NorthWest');
legend boxoff;

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
