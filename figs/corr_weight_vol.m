function corr_weight_vol()
    % function corr_weight_vol
    %
    % Correlate excised path weights (g) with total volume estimates with each
    % modality.
    %
    % Mark Palmeri
    % mlp6@duke.edu
    % 2013-09-13

    vols = csvread('../data/data.csv');

    % open data file for Rsq metrics to be read into LaTeX doc
    fid = fopen('../data/corr_weight_vol_data.tex','w');
    fprintf(fid,'%% DO NOT MANUAL EDIT THIS FILE\n');
    fprintf(fid,'%% Generated by figs/corr_weight_vol.m\n');

    Pnum = num2cell(vols(:,1));
    mr_total_vol = vols(:,3);
    arfi_total_vol = vols(:,11);
    w = vols(:,18);
    path_vols = vols(:,22);

    mr_total_vol = mr_total_vol/1e3;
    arfi_total_vol = arfi_total_vol/1e3;

    gen_fig_n_fits(fid,w,mr_total_vol,arfi_total_vol,'weight');
    gen_fig_n_fits(fid,path_vols,mr_total_vol,arfi_total_vol,'pathVol');
    gen_fig_n_fits(fid,w,path_vols,path_vols,'path_vol_weight');

    fclose(fid);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function gen_fig_n_fits(fid,w,mr_total_vol,arfi_total_vol,metric)
    % fontsize
    fs = 18;
    figure;
    hold on;

    % circle the outlier(s), > 80g path weight
    gt80g = find(w > 80);

    if(strcmp(metric,'path_vol_weight')),
        plot(w,mr_total_vol,'bx','MarkerSize',14,'LineWidth',3);
        % circle the outlier
        plot(w(gt80g),mr_total_vol(gt80g),'o','MarkerSize',32,'LineWidth',2,'Color','m');
    else,
        plot(w,mr_total_vol,'bx','MarkerSize',14,'LineWidth',3);
        plot(w,arfi_total_vol,'go','MarkerSize',14,'LineWidth',3);
        % circle the outliers
        plot(w(gt80g),mr_total_vol(gt80g),'o','MarkerSize',32,'LineWidth',2,'Color','m');
        plot(w(gt80g),arfi_total_vol(gt80g),'o','MarkerSize',32,'LineWidth',2,'Color','m');
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

    set_axes(gca,fs);

    % lets do a linear regression and see what we get

    % first we need to remove the prostate > 80 g
    less80g = find(w < 80);

    [mr_fit,mr_Rsq]=compute_linreg_Rsq(w(less80g),mr_total_vol(less80g));

    plot(w(less80g),mr_fit,'-b','LineWidth',3);

    if(~strcmp(metric,'path_vol_weight')),
        [arfi_fit,arfi_Rsq]=compute_linreg_Rsq(w(less80g),arfi_total_vol(less80g));
        plot(w(less80g),arfi_fit,'-g','LineWidth',3);
    end;

    if(strcmp(metric,'path_vol_weight')),
        legend(sprintf('R^2 = %.2f',mr_Rsq),'Location','NorthWest');
        legend boxoff;
        fprintf(fid,'\\newcommand{\\pathVolWeightRsq}{%.2f}\n',mr_Rsq);
    else,
        if(strcmp(metric,'pathVol')),
            legend(sprintf('MR (R^2 = %.2f)',mr_Rsq),sprintf('ARFI (R^2 = %.2f)',arfi_Rsq),'Location','NorthEast');
        else,
            legend(sprintf('MR (R^2 = %.2f)',mr_Rsq),sprintf('ARFI (R^2 = %.2f)',arfi_Rsq),'Location','NorthWest');
        end;
        legend boxoff;
        if(strcmp(metric,'pathVol')),
            fprintf(fid,'\\newcommand{\\pathVolMRrsq}{%.2f}\n',mr_Rsq);
            fprintf(fid,'\\newcommand{\\pathVolARFIrsq}{%.2f}\n',arfi_Rsq);
        else, 
            fprintf(fid,'\\newcommand{\\weightMRrsq}{%.2f}\n',mr_Rsq);
            fprintf(fid,'\\newcommand{\\weightARFIrsq}{%.2f}\n',arfi_Rsq);
        end;
    end;

    print('-depsc2',sprintf('corr_%s_vol.eps',metric));
    close;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

