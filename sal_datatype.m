classdef sal_datatype
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                         %
% sal_datatype - class that identifies common types of engine measurement %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% sal_datatype -  version 0.9 - Jacob E. McKenzie - mofified: 01/06/14
% 
% types:
%  - type_unk	: unknown measurement type (catch all)
%  - type_ind	: index measurement (eg. time or crank angle)
%  - type_cylp	: cylinder pressure measurement
%  - type_map	: intake manifold pressure measurement
%  - type_lam   : measurement of engine lambda
%  - type_press : generic measurement of pressure
%  - type_temp	: generic measurement of temperature
%
% methods:
%  - settype - performs a lookup of the variable name and returns the
%	       corresponding type. 
% notes:
%   current version does not include any error checking. Variable names
%   must be hard coded to identify measurement types. This is not optimal.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    enumeration
        typ_unk
        typ_ind
        typ_cylp
        typ_map
        typ_lam
        typ_press
        typ_temp
    end
    
    methods (Static)
        function obj = settype(varn)
            switch varn
                case {'t','theta'}
                    obj = sal_datatype.typ_ind;
                case {'cyl1p','cyl2p','cyl3p','cyl4p', 'cly1p'}
                    obj = sal_datatype.typ_cylp;
                case {'r1map'}
                    obj = sal_datatype.typ_map;
                case {'lam'}
                    obj = sal_datatype.typ_lam;
                otherwise
                    obj = sal_datatype.typ_unk;
            end
        end
    end 
end
