function mr_arfi_path_axes
    % function mr_arfi_path_axes
    %
    % Generate plots of the axis-ratios for MR, ARFI and pathology.
    %
    % Mark Palmeri
    % mlp6@duke.edu
    % 2013-09-14

    data = csvread('../data/data.csv');

    Pnum = num2cell(data(:,1));

    % ordering the axes as:
    % (1) APEX-TO-BASE (axial)
    % (2) LATERAL-TO-LATERAL (lat)
    % (3) ANTERIOR-TO-POSTERIOR (elev)
    MR_central_axes = [data(:,4:6)];
    MR_total_axes = [data(:,7:9)];
    ARFI_central_axes = [data(:,12:14)];
    ARFI_total_axes = [data(:,15:18)];
    PATH_total_axes = [data(:,19:21)];

    titles={'(Lateral-to-Lateral : Apex-to-Base)',...
            '(Anterior-to-Posterior : Apex-to-Base)',...
            '(Lateral-to-Lateral : Anterior-to-Posterior)'};
    axis_titles={'Apex-to-Base',...
            'Lateral-to-Lateral',...
            'Anterior-to-Posterior'};

    % fontsize
    fs = 18;

    % open up the table of axis errors and Rsq data files for LaTeX doc inputs
    latex_fid = fopen('../data/mr_arfi_axes_error_data.tex','w');
    print_data_header(latex_fid);
    rsq_fid = fopen('../data/mr_arfi_axes_Rsq.tex','w');
    print_data_header(rsq_fid);

    % lets plot some direct axis measurements of the total prostate and central gland
    for i=1:3,
        figure;
        hold on;
        plot(PATH_total_axes(:,i),MR_total_axes(:,i)/10,'bx','MarkerSize',14,'LineWidth',3);
        plot(PATH_total_axes(:,i),ARFI_total_axes(:,i)/10,'go','MarkerSize',14,'LineWidth',3);
        xlabel('Pathology Measurement (cm)','FontSize',fs);
        ylabel('Imaging Measurement (cm)','FontSize',fs);

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

         [mr_fit,mr_Rsq]=compute_linreg_Rsq(PATH_total_axes(:,i),MR_total_axes(:,i)/10);
         plot(PATH_total_axes(:,i),mr_fit,'-b','LineWidth',3);
         [arfi_fit,arfi_Rsq]=compute_linreg_Rsq(PATH_total_axes(:,i),ARFI_total_axes(:,i)/10);
         plot(PATH_total_axes(:,i),arfi_fit,'-g','LineWidth',3);

       axis([2 8 2 8]); 

       title(sprintf('%s',axis_titles{i}),'FontSize',fs);

       switch i
       case 1
           legend(sprintf('MR (R^2 = %.2f)',mr_Rsq),sprintf('ARFI (R^2 = %.2f)',arfi_Rsq),'Location','NorthWest');
        case 2
           legend(sprintf('MR (R^2 = %.2f)',mr_Rsq),sprintf('ARFI (R^2 = %.2f)',arfi_Rsq),'Location','SouthEast');
        case 3
           legend(sprintf('MR (R^2 = %.2f)',mr_Rsq),sprintf('ARFI (R^2 = %.2f)',arfi_Rsq),'Location','NorthWest');
       end;
       legend boxoff;

        % add "ideal" line
        line([2 8],[2 8],'LineStyle','--','Color','k','LineWidth',3);

        print('-depsc2',sprintf('%s.eps',axis_titles{i}));
        print('-dpng',sprintf('%s.png',axis_titles{i}));
        close;

        % compute over/unders for each modality
        mr_axis_OverUnder(:,i) = compute_over_under(PATH_total_axes(:,i),MR_total_axes(:,i)/10);
        arfi_axis_OverUnder(:,i) = compute_over_under(PATH_total_axes(:,i),ARFI_total_axes(:,i)/10);
    end;

    % let's make plots of the correlation between MR:ARFI for total gland and central gland
    for i=1:3,
        figure;
        hold on;
        plot(MR_total_axes(:,i)/10,ARFI_total_axes(:,i)/10,'rx','MarkerSize',14,'LineWidth',3);
        plot(MR_central_axes(:,i)/10,ARFI_central_axes(:,i)/10,'bo','MarkerSize',14,'LineWidth',3);
        xlabel('MR Measurement (cm)','FontSize',fs);
        ylabel('ARFI Measurement (cm)','FontSize',fs);

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

         [image_total_fit,image_total_Rsq]=compute_linreg_Rsq(MR_total_axes(:,i)/10,ARFI_total_axes(:,i)/10);
         plot(MR_total_axes(:,i)/10,image_total_fit,'-r','LineWidth',3);
         [image_central_fit,image_central_Rsq]=compute_linreg_Rsq(MR_central_axes(:,i)/10,ARFI_central_axes(:,i)/10);
         plot(MR_central_axes(:,i)/10,image_central_fit,'-b','LineWidth',3);

       axis([2 8 2 8]); 

       title(sprintf('%s Axis',axis_titles{i}),'FontSize',fs);

       % print legends and Rsq data for inclusion in LaTeX doc
       switch i
       case 1
           legend(sprintf('Total Gland (R^2 = %.2f)',image_total_Rsq),sprintf('Central Gland (R^2 = %.2f)',image_central_Rsq),'Location','NorthWest');
           fprintf(rsq_fid,'\\newcommand{\\totalApexBaseRsq}{%.2f}\n',image_total_Rsq);
           fprintf(rsq_fid,'\\newcommand{\\centralApexBaseRsq}{%.2f}\n',image_central_Rsq);
        case 2
           legend(sprintf('Total Gland (R^2 = %.2f)',image_total_Rsq),sprintf('Central Gland (R^2 = %.2f)',image_central_Rsq),'Location','SouthEast');
           fprintf(rsq_fid,'\\newcommand{\\totalLatLatRsq}{%.2f}\n',image_total_Rsq);
           fprintf(rsq_fid,'\\newcommand{\\centralLatLatRsq}{%.2f}\n',image_central_Rsq);
        case 3
           legend(sprintf('Total Gland (R^2 = %.2f)',image_total_Rsq),sprintf('Central Gland (R^2 = %.2f)',image_central_Rsq),'Location','NorthWest');
           fprintf(rsq_fid,'\\newcommand{\\totalAntPostRsq}{%.2f}\n',image_total_Rsq);
           fprintf(rsq_fid,'\\newcommand{\\centralAntPostRsq}{%.2f}\n',image_central_Rsq);
       end;
       legend boxoff;

        % add "ideal" line
        line([2 8],[2 8],'LineStyle','--','Color','k','LineWidth',3);

        print('-depsc2',sprintf('Imaging_%s.eps',axis_titles{i}));
        print('-dpng',sprintf('Imaging_%s.png',axis_titles{i}));
        close;

        % compute over/unders for each modality
        mr_arfi_total_OverUnder(:,i) = compute_over_under(MR_total_axes(:,i)/10,ARFI_total_axes(:,i)/10);
        mr_arfi_central_OverUnder(:,i) = compute_over_under(MR_central_axes(:,i)/10,ARFI_central_axes(:,i)/10);
    end;

    fclose(rsq_fid);

    %disp('MR:ARFI Total and Central');
    %mean(mr_arfi_total_OverUnder)
    %std(mr_arfi_total_OverUnder)
    %mean(mr_arfi_central_OverUnder)
    %std(mr_arfi_central_OverUnder)
    print_mr_arfi_axes_error_tex_data(latex_fid,mr_arfi_total_OverUnder,mr_arfi_central_OverUnder);

    % I will now compute ratios of AB:LL (1:2), AB:AP (1:3), and LL:AP (2:3) for
    % imaging central and total and path total volumes
    MR_central_ratios = compute_ratios(MR_central_axes);
    MR_total_ratios = compute_ratios(MR_total_axes);
    ARFI_central_ratios = compute_ratios(ARFI_central_axes);
    ARFI_total_ratios = compute_ratios(ARFI_total_axes);
    PATH_total_ratios = compute_ratios(PATH_total_axes);

    % create a file for writing the data for LaTeX table
    fid = fopen('tab_axis_ratio_over_under_data.tex','w');

    for i=1:3,
        figure;
        hold on;
        bar_width = 0.25;
        h=bar([1:length(MR_total_ratios(:,i))],MR_total_ratios(:,i),bar_width);
        g=bar([1:length(ARFI_total_ratios(:,i))]+bar_width,ARFI_total_ratios(:,i),bar_width);
        f=bar([1:length(PATH_total_ratios(:,i))]+2*bar_width,PATH_total_ratios(:,i),bar_width);
        set(h(1),'FaceColor',[0 0 1]);
        set(g(1),'FaceColor',[0 1 0]);
        set(f(1),'FaceColor',[1 0 0]);
        ylabel('Axis Ratios','FontSize',fs)
        xlabel('Study Subject','FontSize',fs);
        title(sprintf('Total Prostate Axes: %s',titles{i}),'FontSize',fs);
        a=axis;
        a(2) = 17;
        axis(a);
        legend('MR (Blue)','ARFI (Green)','PATH (Red)','Location','NorthEast');
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

        print('-depsc2',sprintf('mr_arfi_total_axes%i.eps',i));
        print('-dpng',sprintf('mr_arfi_total_axes%i.png',i));
        close;
    end;

    for i=1:3,
        figure;
        hold on;
        bar_width = 0.33;
        h=bar([1:length(MR_central_ratios(:,i))],MR_central_ratios(:,i),bar_width);
        g=bar([1:length(ARFI_central_ratios(:,i))]+bar_width,ARFI_central_ratios(:,i),bar_width);
        set(h(1),'FaceColor',[0 0 1]);
        set(g(1),'FaceColor',[0 1 0]);
        ylabel('Axis Ratios','FontSize',fs)
        xlabel('Study Subject','FontSize',fs);
        title(sprintf('Central Gland / Zone Axes: %s',titles{i}),'FontSize',fs);
        a=axis;
        a(2) = 17;
        axis(a);
        legend('MR (Blue)','ARFI (Green)','Location','NorthWest');
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

        print('-depsc2',sprintf('mr_arfi_central_axes%i.eps',i));
        print('-dpng',sprintf('mr_arfi_central_axes%i.png',i));
        close;
    end;

    % now lets compute how much over/under estimation of axis ratios ARFI is compared to the MR (and PATH).
    ARFI_MR_Total_OverUnder = compute_over_under(MR_total_ratios,ARFI_total_ratios);
    ARFI_PATH_Total_OverUnder = compute_over_under(PATH_total_ratios,ARFI_total_ratios);
    MR_PATH_Total_OverUnder = compute_over_under(PATH_total_ratios,MR_total_ratios);
    ARFI_MR_Central_OverUnder = compute_over_under(MR_central_ratios,ARFI_central_ratios);

    axis_combos = {'LL:AB','AP:AB','LL:AP'};
    % another set of bar plots! 
    for i=1:3,
        figure;
        hold on;
        bar_width=0.25;
        h=bar([1:length(ARFI_MR_Total_OverUnder(:,i))],ARFI_MR_Total_OverUnder(:,i),bar_width);
        g=bar([1:length(ARFI_PATH_Total_OverUnder(:,i))]+bar_width,ARFI_PATH_Total_OverUnder(:,i),bar_width);
        f=bar([1:length(MR_PATH_Total_OverUnder(:,i))]+2*bar_width,MR_PATH_Total_OverUnder(:,i),bar_width);
        set(h(1),'FaceColor',[0 0 1]);
        set(g(1),'FaceColor',[0 1 0]);
        set(f(1),'FaceColor',[1 0 0]);
        ylabel('Percent Axis Ratio Differences','FontSize',fs)
        xlabel('Study Subject','FontSize',fs);
        title(sprintf('Total Prostate Axes: %s',titles{i}),'FontSize',fs);
        a=axis;
        a(2) = 17;
        axis(a);
        legend('ARFI:MR (Blue)','ARFI:PATH (Green)','MR:PATH (Red)','Location','NorthEast');
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

        print('-depsc2',sprintf('mr_arfi_total_over_under%i.eps',i));
        print('-dpng',sprintf('mr_arfi_total_over_under%i.png',i));
        close;

        % while I'm here, lets compute some stats to include in the caption / text, and LaTeX format it!!
        fprintf(fid,'ARFI & MR & Total & %s & %.1f $\\pm$ %.1f \\\\ \n',axis_combos{i},mean(ARFI_MR_Total_OverUnder(:,i)),std(ARFI_MR_Total_OverUnder(:,i)));
        fprintf(fid,'ARFI & PATH & Total & %s & %.1f $\\pm$  %.1f \\\\ \n',axis_combos{i},mean(ARFI_PATH_Total_OverUnder(:,i)),std(ARFI_PATH_Total_OverUnder(:,i)));
        fprintf(fid,'MR & PATH & Total & %s & %.1f $\\pm$ %.1f \\\\ \n',axis_combos{i},mean(MR_PATH_Total_OverUnder(:,i)),std(MR_PATH_Total_OverUnder(:,i)));
    end;

    for i=1:3,
        figure;
        hold on;
        bar_width=0.5;
        h=bar([1:length(ARFI_MR_Central_OverUnder(:,i))],ARFI_MR_Central_OverUnder(:,i),bar_width);
        set(h(1),'FaceColor',[0 0 1]);
        ylabel('Percent Axis Ratio Differences','FontSize',fs)
        xlabel('Study Subject','FontSize',fs);
        title(sprintf('Central Gland / Zone Axes: %s',titles{i}),'FontSize',fs);
        a=axis;
        a(2) = 17;
        axis(a);

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

        print('-depsc2',sprintf('mr_arfi_central_over_under%i.eps',i));
        print('-dpng',sprintf('mr_arfi_central_over_under%i.png',i));
        close;
        fprintf(fid,'ARFI & MR & Central & %s & %.1f $\\pm$ %.1f \\\\ \n',axis_combos{i},mean(ARFI_MR_Central_OverUnder(:,i)),std(ARFI_MR_Central_OverUnder(:,i)));
    end;

    fclose(latex_fid)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [ratios]=compute_ratios(axes)
    ratios(:,1) = axes(:,2)./axes(:,1);
    ratios(:,2) = axes(:,3)./axes(:,1);
    ratios(:,3) = axes(:,3)./axes(:,2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [over_under]=compute_over_under(mr,arfi)
    over_under = 100*(arfi-mr)./mr;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function print_mr_arfi_axes_error_tex_data(fid,total,central)
    total_means = mean(total);
    total_stds = std(total);
    central_means = mean(central);
    central_stds = std(central);
    
    fprintf(fid,'\\newcommand{\\ARFImrTotalLatLatMeanPct}{%.1f}\n',total_means(2));
    fprintf(fid,'\\newcommand{\\ARFImrCentralLatLatMeanPct}{%.1f}\n',central_means(2));
    fprintf(fid,'\\newcommand{\\ARFImrTotalLatLatStdPct}{%.1f}\n',total_stds(2));
    fprintf(fid,'\\newcommand{\\ARFImrCentralLatLatStdPct}{%.1f}\n',central_stds(2));
    fprintf(fid,'\\newcommand{\\ARFImrTotalAntPostMeanPct}{%.1f}\n',total_means(3));
    fprintf(fid,'\\newcommand{\\ARFImrCentralAntPostMeanPct}{%.1f}\n',central_means(3));
    fprintf(fid,'\\newcommand{\\ARFImrTotalAntPostStdPct}{%.1f}\n',total_stds(3));
    fprintf(fid,'\\newcommand{\\ARFImrCentralAntPostStdPct}{%.1f}\n',central_stds(3));
    fprintf(fid,'\\newcommand{\\ARFImrTotalApexBaseMeanPct}{%.1f}\n',total_means(1));
    fprintf(fid,'\\newcommand{\\ARFImrCentralApexBaseMeanPct}{%.1f}\n',central_means(1));
    fprintf(fid,'\\newcommand{\\ARFImrTotalApexBaseStdPct}{%.1f}\n',total_stds(1));
    fprintf(fid,'\\newcommand{\\ARFImrCentralApexBaseStdPct}{%.1f}\n',central_stds(1));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function print_data_header(fid)
    fprintf(fid,'%% DO NOT MANUALLY EDIT THIS FILE\n');
    fprintf(fid,'%% Generated by figs/mr_arfi_path_axes.m\n');
