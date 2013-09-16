function [fit,Rsq]=compute_linreg_Rsq(w,total_vol)
    p = polyfit(w,total_vol,1);
    fit = polyval(p,w);
    resid = total_vol - fit;
    ss_resid = sum(resid.^2);
    ss_total = (length(total_vol)- 1) * var(total_vol);
    Rsq = 1 - ss_resid / ss_total

