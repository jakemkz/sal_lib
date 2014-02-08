classdef sal_datanote
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                         %
%   sal_datanote - class containing a note about a particular datapoint   %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% sal_datanote -  version 0.9 - Jacob E. McKenzie - mofified: 01/06/14
% 
% properties:
%  - longname	[string] : descriptive name of measurement channel
%  - varname	[string] : variable name, meets matlab var name standards
%  - value	[double] : scalar numeric value of note
%  - units	[string] : units of value property
%  - desc	[string] : textual content of note (if specified)
%
% methods:
%  - sal_datanote - constructor function, pass in a cell vector that
%		    contains the individual elements of the note in a
%		    specified order.
% notes:
%   current version does not include any error checking 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    properties
        longname
        varname
        value
        units
        desc
    end
    
    methods
        function dnote = sal_datanote(notesvec)
            dnote.longname = notesvec{1};
            dnote.varname  = notesvec{2};
            dnote.value    = notesvec{4};
            dnote.units    = notesvec{5};
            dnote.desc     = notesvec{3};
        end
    end
end
        
