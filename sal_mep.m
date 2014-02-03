function [gimep, nimep] = sal_mep(cylp, dv, vd)

dW = cylp.*(dv);
%plot(dW)
nimep = sum(dW)/vd;
gimep = sum(dW(1:floor(length(dW)/2),:))/vd;