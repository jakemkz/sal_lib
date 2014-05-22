function [m_fuel, LHV, e_evap] = sal_fuelinj(p_fuel, pw_fuel, varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                         %
%  sal_fuelinj - compute the mass of fuel injected in one injection event %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% sal_fuelinj -  version 0.92 - Jacob E. McKenzie - mofified: 05/05/14
% 
% inputs:
%  - p_fuel	 [Mpa] : fuel rail pressure
%  - pw_fuel [ms]  : fuel injector signal pulsewidth
%  - fuel	 [str] : fuel name, string input
%
% output:
%  - m_fuel	  [kg]   : mass of fuel injected in one injection event
%  - LHV_fuel [J/kg] : lower heating value of fuel
%  - e_evap   [J]    : energy consumed by fuel evaporation
%
% notes:
%  current version does not include any error checking. p_fuel and pw_fuel
%  should be the same size (scalar or vector). m_fuel will be the same size
%  as the two input variables.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% parse optional arguments
narginchk(2,3);
if (nargin == 3)
  fuel = varargin{1};
else
  fuel = 'HF0437';
end


switch upper(fuel)
  case { 'HF0437' , 'HF437' }
    % Haltermann HF0437 96 RON ref. fuel
    AFR = 14.6742;
    rho = 0.7374;
    LHV = 44.0e6; % [J/kg]
    h_v = 350e3;  % [J/kg]
  
  otherwise
    % case for unidentifiable fuel type (assume generic gasoline)
    AFR = 14.7;
    rho = 0.744;
    LHV = 44.0e6; % [J/kg]
    h_v = 350e3;  % [J/kg]
end

% calibration  map of fuel injector. At the pressures given by p_ref the
% flow rate of fuel through a continuously open fuel injector is measured
% and recorded as v_ref. Next the injector is driven at a high frequency
% and the flow rate is measured again. t_ref is the delay during which no
% fuel is injected. 
p_ref = [4.081513524; 7.095787287; 10.0785737; 15.0989902]; % [MPa]
v_ref = [10.34; 13.61; 16.40; 20.20];			            % [mg/ms]
t_ref = [0.0517; 0.0753; 0.0848; 0.1039];		            % [ms]
rho_ref = 0.744; % density of calibration fuel

slope  = interp1(p_ref,v_ref,p_fuel);
offset = interp1(p_ref,t_ref,p_fuel);

m_fuel = ((pw_fuel-offset).*slope*(rho/rho_ref))*10^(-6); % [kg]
e_evap = h_v*m_fuel;                                      % [J]
end