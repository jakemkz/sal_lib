classdef sal_datachan
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                         %
% sal_datachan - class containing info. regarding one measurement channel %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% sal_datachan -  version 0.9 - Jacob E. McKenzie - mofified: 01/06/14
% 
% properties:
%  - longname	[string] : descriptive name of measurement channel
%  - varname	[string] : variable name, meets matlab var name standards
%  - units	[string] : units of values stored in data
%  - data	[double] : scalar, vector or matrix of data values
%  - type	[sal_datatype] : type of measurement channel. see 
%				 sal_datatype definition for more info.
%
% methods:
%  - sal_datachan - constructor function, pass in all properties except 
%		    type to create a sal_datachan object.
%
% notes:
%   current version does not include any error checking 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    properties
        longname
        varname
        units
        data
        type
    end
    
    methods
        function dchan = sal_datachan(longn, varn, units, data)
            dchan.longname = longn;		% long format name
            dchan.varname  = varn;		% variable format name
            dchan.units    = units;		% units of data
            dchan.data     = squeeze(data);	% data matrix
            dchan.type     = sal_datatype.settype(varn); % data type
        end
    end
end
