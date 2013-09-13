% gen_latex_tab.m
%
% generate LaTeX table from CSV file
% 
% Mark Palmeri
% mlp6@duke.edu
% 2013-09-13

data = csvread('Prostate_CZ_PZ_Volume_Axis_Measurements.csv');

fid=fopen('vol_data.tex','w');

for i=1:size(data,1),
    fprintf(fid,'%i & %.2f & %.2f & %.2f & %.2f \\\\ \n',i,data(i,2)/1e3,data(i,3)/1e3,data(i,10)/1e3,data(i,11)/1e3);
end;

fclose(fid);
