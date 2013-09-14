% corr_weight_vol.m
%
% Correlate excised path weights (g) with total volume estimates with each
% modality.
%
% Mark Palmeri
% mlp6@duke.edu
% 2013-09-13

vols = csvread('../data/Prostate_CZ_PZ_Volume_Axis_Measurements.csv');

Pnum = num2cell(vols(:,1));
mr_total_vol = vols(:,3);
arfi_total_vol = vols(:,11);
w = vols(:,12);

mr_total_vol = mr_total_vol/1e3;
arfi_total_vol = arfi_total_vol/1e3;

% fontsize
fs = 18;

figure;
hold on;
plot(w,mr_total_vol,'bx','MarkerSize',14,'LineWidth',3);
plot(w,arfi_total_vol,'go','MarkerSize',14,'LineWidth',3);
ylabel('Total Volume (cm^3)','FontSize',fs)
xlabel('Prostate Weight (g)','FontSize',fs);

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

% lets do a linear regression and see what we get
mr_p = polyfit(w,mr_total_vol,1);
mr_fit = polyval(mr_p,w);
mr_resid = mr_total_vol - mr_fit;
mr_ss_resid = sum(mr_resid.^2);
mr_ss_total = (length(mr_total_vol)- 1) * var(mr_total_vol);
mr_Rsq = 1 - mr_ss_resid / mr_ss_total

plot(w,mr_fit,'-b','LineWidth',3);

arfi_p = polyfit(w,arfi_total_vol,1);
arfi_fit = polyval(arfi_p,w);
arfi_resid = arfi_total_vol - arfi_fit;
arfi_ss_resid = sum(arfi_resid.^2);
arfi_ss_total = (length(arfi_total_vol)- 1) * var(arfi_total_vol);
arfi_Rsq = 1 - arfi_ss_resid / arfi_ss_total

plot(w,arfi_fit,'-g','LineWidth',3);

legend(sprintf('MR (R^2 = %.2f)',mr_Rsq),sprintf('ARFI (R^2 = %.2f)',arfi_Rsq),'Location','NorthWest');
legend boxoff;

print('-depsc2','corr_weight_vol.eps');

system('convert_eps_to_pdf.sh');
