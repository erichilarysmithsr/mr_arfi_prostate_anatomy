function mr_arfi_path_axes
    % function mr_arfi_path_axes
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
    MR_central_axes = [data(:,4:6)];
    MR_total_axes = [data(:,7:9)];
    ARFI_central_axes = [data(:,12:14)];
    ARFI_total_axes = [data(:,15:18)];
    PATH_total_axes = [data(:,19:21)];

    % I will now compute ratios of AB:LL (1:2), AB:AP (1:3), and LL:AP (2:3) for
    % imaging central and total and path total volumes
    MR_central_ratios = compute_ratios(MR_central_axes);
    MR_total_ratios = compute_ratios(MR_total_axes);
    ARFI_central_ratios = compute_ratios(ARFI_central_axes);
    ARFI_total_ratios = compute_ratios(ARFI_total_axes);
    PATH_total_ratios = compute_ratios(PATH_total_axes);

    % fontsize
    fs = 18;

    titles={'(Lateral-to-Lateral : Apex-to-Base)',...
            '(Anterior-to-Posterior : Apex-to-Base)',...
            '(Lateral-to-Lateral : Anterior-to-Posterior)'};

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
        title(sprintf('Total Prostate Axes: %s',titles{i}),'FontSize',fs);
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
        close;
    end;

function [ratios]=compute_ratios(axes)
    ratios(:,1) = axes(:,2)./axes(:,1);
    ratios(:,2) = axes(:,3)./axes(:,1);
    ratios(:,3) = axes(:,3)./axes(:,2);
