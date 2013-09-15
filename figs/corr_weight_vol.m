function corr_weight_vol()
    % function corr_weight_vol
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
    path_vols = vols(:,16);

    mr_total_vol = mr_total_vol/1e3;
    arfi_total_vol = arfi_total_vol/1e3;

    gen_fig_n_fits(w,mr_total_vol,arfi_total_vol,'weight');
    gen_fig_n_fits(path_vols,mr_total_vol,arfi_total_vol,'pathVol');
    gen_fig_n_fits(w,path_vols,path_vols,'path_vol_weight');

    system('convert_eps_to_pdf.sh');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function gen_fig_n_fits(w,mr_total_vol,arfi_total_vol,metric)
    % fontsize
    fs = 18;
    figure;
    hold on;
    if(strcmp(metric,'path_vol_weight')),
        plot(w,mr_total_vol,'bx','MarkerSize',14,'LineWidth',3);
    else,
        plot(w,mr_total_vol,'bx','MarkerSize',14,'LineWidth',3);
        plot(w,arfi_total_vol,'go','MarkerSize',14,'LineWidth',3);
    end;
    if(strcmp(metric,'path_vol_weight')),
        ylabel('Pathology Ellipsoidal Volume (cm^3)','FontSize',fs)
    else,
        ylabel('Total Volume (cm^3)','FontSize',fs)
    end;
    if(strcmp(metric,'weight') || strcmp(metric,'path_vol_weight')),
        xlabel('Prostate Weight (g)','FontSize',fs);
    elseif(strcmp(metric,'pathVol')),
        xlabel('Prostate Pathology Volume (cm^3)','FontSize',fs);
    end;

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
    [mr_fit,mr_Rsq]=compute_linreg_Rsq(w,mr_total_vol);

    plot(w,mr_fit,'-b','LineWidth',3);

    if(~strcmp(metric,'path_vol_weight')),
        [arfi_fit,arfi_Rsq]=compute_linreg_Rsq(w,arfi_total_vol);

        plot(w,arfi_fit,'-g','LineWidth',3);

    end;

    if(strcmp(metric,'path_vol_weight')),
        legend(sprintf('R^2 = %.2f',mr_Rsq),'Location','NorthWest');
        legend boxoff;
    else,
        legend(sprintf('MR (R^2 = %.2f)',mr_Rsq),sprintf('ARFI (R^2 = %.2f)',arfi_Rsq),'Location','NorthWest');
        legend boxoff;
    end;

    print('-depsc2',sprintf('corr_%s_vol.eps',metric));
    close;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [fit,Rsq]=compute_linreg_Rsq(w,total_vol)
    p = polyfit(w,total_vol,1);
    fit = polyval(p,w);
    resid = total_vol - fit;
    ss_resid = sum(resid.^2);
    ss_total = (length(total_vol)- 1) * var(total_vol);
    Rsq = 1 - ss_resid / ss_total
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
