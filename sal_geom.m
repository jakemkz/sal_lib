function geom = sal_geom()

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                         %
%          sal_geom - define engine-specific geometrical constants        %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% sal_geom -  version 0.9 - Jacob E. McKenzie - mofified: 01/02/14
% 
% outputs:
%   - geom.offset       [cad]: offset of ca = 0 from true BDC (encoder offset)
%   - geom.bore         [m]  : cylinder bore
%   - geom.stroke       [m]  : stroke
%   - geom.rod          [m]  : connecting rod length
%   - geom.rc           [1]  : compression ratio
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% constants for GM LNF
geom.bore   = 0.086;
geom.stroke = 0.086;
geom.rod    = 0.1455;
geom.rc     = 9.2;
geom.offset = 0.0; 

end
