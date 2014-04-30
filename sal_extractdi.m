function [di_chan] = sal_extractdi(di_group,chan)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                         %
%      sal_extractdi - extract a digital output channel from a byte       %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% sal_extractdi -  version 0.90 - Jacob E. McKenzie - mofified: 04/30/14
% 
% inputs:
%   - di_group [int] : a gruop of digital channels stored in one byte
%   - chan     [int] : the desired output channel (valid range 1 to 4)
%
% outputs:
%   - di_chan  [bool] : the value of the output channel
%
% notes:
%   - current version does not perform error checking
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

bytes   = dec2bin(di_group,4);
di_chan = bytes(:,chan)-'0';

end