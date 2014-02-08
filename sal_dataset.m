classdef sal_dataset
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                         %
%  sal_dataset - class containing several measurements collected together %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% sal_dataset -  version 0.9 - Jacob E. McKenzie - mofified: 01/06/14
% 
% properties:
%  - samptype	[int]    : type of sampling 1 means crank angle resolved
%			   and 2 means time resolved
%  - sampling	[string] : sampling interval either "N/CAD" where N is
%			   the number of samples per crank angle or
%			   "FHz" where F is the sampling freq. in Hz.
%  - trigger	[string] : the trigger used to begin acquisition of data
%  - chan	[sal_datachan] : vector of type sal_datachan containing
%				 all measurement channels and their data
%
% methods:
%  - sal_dataset - multi-mode constructor function. If one argument is
%		   used, that argument is assumed to be the file identifier
%		   otherwise the arguments are assigned to the properties 
%		   directly.
%  - index	 - return the channels identified as sal_datatype "type_ind"
%  - cylp	 - return the channels identified as sal_datatype "type_cylp"
%
% notes:
%  current version does not include any error checking. The read from 
%  file functionality requires particular formatting of the binary file.
%  For more on this format see the lvb format definition.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    properties
        samptype
        sampling
        trigger
        chan
    end
    
    methods
        % constructor function
        function dset = sal_dataset(varargin)
	    % read form file
            if length(varargin) == 1
                fid = varargin{1};
                
                dset.samptype = lvb_readdbl(fid,1); % 1 = CA 2 = time
                dset.sampling = lvb_readstr(fid,1);
                dset.trigger  = lvb_readstr(fid,1);
                
                longnames = lvb_readarr(fid,1,@lvb_readstr);
                varnames  = lvb_readarr(fid,1,@lvb_readstr);
                units     = lvb_readarr(fid,1,@lvb_readstr);
                data      = lvb_readarr(fid,3,@lvb_readdbl);
                
                dset.chan = sal_datachan.empty(1,0);
                for i = 1:length(longnames)
                    dset.chan(i) = sal_datachan(longnames{i},varnames{i},...
                        units{i},data(:,i,:));
                end
            % assign properties from arguments
            else
                dset.samptype = varargin{1};
                dset.sampling = varargin{2};
                dset.trigger  = varargin{3};
                dset.chan     = varargin{4};
            end
        end
        
        %%%
        %%% alias functions (filtering functions)
        %%%
        
        % find index channel
        function indchan = index(dset)
            indchan = dset.chan([dset.chan.type] == sal_datatype.typ_ind);
        end
        
        % find cylinder pressure channel
        function cylpchan = cylp(dset)
            cylpchan = dset.chan([dset.chan.type] == sal_datatype.typ_cylp);
        end
    end
end
