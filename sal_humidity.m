function [x_h2o] = sal_humidity(p,T,RH)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                         %
%   sal_humidity - calculate h2o mole fraction from temp. and humidity    %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% sal_humidity - version 0.90 - Jacob E. McKenzie - mofified: 05/05/14
% 
% inputs:
%  - p [mbar] : absolute pressure
%  - T	  [C] : ambient temperature
%  - RH   [%] : relative humidity
%
% output:
%  - x_h2o	  [1]   : mole fraction of h2o in air
%
% notes:
%  no error checking. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% constants
a = 6.1121; %millibar
b = 18.678;
c = 257.14; % deg C
d = 234.5;  % deg C

g     = log(RH/100*exp((b-T/d)*(T/(c+T))));
P     = a*exp(g);
x_h2o = P/p;
end