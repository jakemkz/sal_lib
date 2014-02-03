function [cyl_v, cyl_dv, vd] = sal_cylv(ca)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                         %
%          sal_cylv - calculate cylinder volume based on geometry         %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% sal_cylv -  version 0.91 - Jake McKenzie - mofified: 01/02/14
% 
% inputs:
%   - ca                [cad]: crank angle aBDC compression, may be a vector
%   - geom                   : struct created based on constants in sal_geom
%   - geom.offset       [cad]: offset of ca = 0 from true BDC
%   - geom.bore         [m]  : cylinder bore
%   - geom.stroke       [m]  : stroke
%   - geom.rod          [m]  : connecting rod length
%   - geom.rc           [1]  : compression ratio
%
% outputs:
%   - cyl_v             [m^3]: cylinder volume, crank angle resolved
%   - cyl_dv            [m^3]: change in cylinder volume
%   - vd                [m^3]: displacement volume
%
% notes:
%   current version does not include wrist pin offset.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% obtain geometrical constants using from sal_geom
geom = sal_geom;

vd = pi*(geom.bore/2)^2*geom.stroke;    % displacement volume in m^3;
vc = vd/(geom.rc-1);                    % clearance volume in m^3;

t = (ca-180-geom.offset)*pi/180;
r = geom.rod/(0.5*geom.stroke);

% dimensionless cylinder volume (v/vc) - Heywood pg. 44
v = 1 + (geom.rc-1)/2*(r+1-cos(t)-sqrt((r.^2 - sin(t).^2)));

% dimensionless piston speed (sp/2nL)
%sp = -pi/2*sin(t).*(1+cos(t)./sqrt((r.^2-sin(t).^2));

% cylinder volume in m^3;
[m, n] = size(v);
cyl_v  = v*vc;
cyl_dv = reshape(circshift(v(:)*vc,-1) - v(:)*vc,m,n);
