function [gimep, nimep] = sal_mep(cylp, dv, vd)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%									                                      %
%  sal_mep - compute the gross and net indicated mean effective pressure  %
%									                                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% sal_mep - version 1.0 - Jacob E. McKenzie - modified: 01/04/14
%
% inputs:
%  - cylp	[pressure] : cylinder pressure as a function of crank angle
%			             nsamp by ncycle matrix, where nsamp is the
%			             number of samples per engine cycle and ncycle
%			             is the number of cycles to be analyzed. 
%  - dv		[volume]   : cylinder volume as a function of crank angle
%			             nsamp by ncycle matrix
%  - vd     [volume]   : displacement volume (scalar value)
%
% outputs:
%  - gimep 	[pressure] : the gross indicated mean effective pressure
%  - nimep	[pressure] : the net indicated mean effective pressure
%
% notes:
%  - Current version contains no error checking.
%  - Code works as long as consistent units are used for dv and vd. The
%    gimep and nimep are returned in the same units as the provided cylinder
%    pressure. 
%  - Both gimep and nimep are 1 by ncycle vectors.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dW    = cylp.*(dv);
nimep = sum(dW)/vd;
gimep = sum(dW(1:floor(length(dW)/2),:))/vd;

end
