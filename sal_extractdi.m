function [di_chan] = sal_extractdi(di_group,chan)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                         %
%      sal_extractdi - extract a digital output channel from a byte       %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% sal_extractdi -  version 0.91 - Jacob E. McKenzie - mofified: 05/22/14
% 
% inputs:
%   - di_group [int] : a gruop of digital channels stored in one byte
%   - chan     [int] : the desired output channel (valid range 0 to ...)
%
% outputs:
%   - di_chan  [bool] : the value of the output channel
%
% notes:
%   - current version does not perform error checking
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

di_chan = bitand(di_group,2^chan)./2^chan;

end