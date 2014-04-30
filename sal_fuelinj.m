function [m_fuel, varargout] = sal_fuelinj(p_fuel, pw_fuel, varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                         %
%  sal_fuelinj - compute the mass of fuel injected in one injection event %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% sal_fuelinj -  version 0.91 - Jacob E. McKenzie - mofified: 04/29/14
% 
% inputs:
%  - p_fuel	 [Mpa] : fuel rail pressure
%  - pw_fuel [ms]  : fuel injector signal pulsewidth
%  - fuel	 [str] : fuel name, string input
%
% output:
%  - m_fuel	  [g]    : mass of fuel injected in one injection event
%  - LHV_fuel [J/kg] : lower heating value of fuel
%
% notes:
%  current version does not include any error checking. p_fuel and pw_fuel
%  should be the same size (scalar or vector). m_fuel will be the same size
%  as the two input variables.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% parse optional arguments
narginchk(2,3);
nargoutchk(1,2);
if (nargin == 3)
  fuel = varargin{1};
end


switch upper(fuel)
  case { 'HF0437' , 'HF437' }
    % Haltermann HF0437 96 RON ref. fuel
    AFR = 14.6742;
    rho = 0.7374;
    LHV = 44.0e6;
  
  otherwise
    % case for unidentifiable fuel type (assume gasoline)
    AFR = 14.7;
    rho = 0.744;
    LHV = 44.0e6;
end

% calibration  map of fuel injector. At the pressures given by p_ref the
% flow rate of fuel through a continuously open fuel injector is measured
% and recorded as v_ref. Next the injector is driven at a high frequency
% and the flow rate is measured again. t_ref is the delay during which no
% fuel is injected. 
p_ref = [4.081513524; 7.095787287; 10.0785737; 15.0989902]; % [MPa]
v_ref = [10.34; 13.61; 16.40; 20.20];			    % [mg/ms]
t_ref = [0.0517; 0.0753; 0.0848; 0.1039];		    % [ms]
rho_ref = 0.744; % density of calibration fuel

slope  = interp1(p_ref,v_ref,p_fuel);
offset = interp1(p_ref,t_ref,p_fuel);

m_fuel = ((pw_fuel-offset).*slope*(rho/rho_ref))*10^(-6); % fuel in kg

% if LHV is requested, return it.
if (nargout == 2)
    varargout{1} = LHV;
end

end
