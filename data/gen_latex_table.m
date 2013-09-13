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

fid = fopen('axis_data.tex','w');

for i=1:size(data,1),
    fprintf(fid,'%i & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f & %.2f \\\\ \n',i,data(i,4)/10,data(i,5)/10,data(i,6)/10,data(i,7)/10,data(i,8)/10,data(i,9)/10,data(i,12)/10,data(i,13)/10,data(i,14)/10,data(i,15)/10,data(i,16)/10,data(i,17)/10);
end;

fclose(fid);
