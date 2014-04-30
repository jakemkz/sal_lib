classdef sal_datapoint
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                         %
%    sal_datapoint - class containing a complete set of data and notes    %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% sal_datapoint -  version 0.9 - Jacob E. McKenzie - mofified: 01/06/14
% 
% properties:
%  - notes	[struct]      : structure containing notes  
%  - dset	[sal_dataset] : vector of data sets containing measurements
%
% methods:
%  - sal_datapoint - constructor function, pass in a path to a lvb file
%		     and the data within that file will be returned as a
%		     sal_datapoint. If multiple arguments are specified
%		     they are taken as the datapoint properties.
%
% notes:
%  current version does not include any error checking. Undocumented
%  member functions are experimental and they should not be assumed
%  correct (or even functional). Member functions that operate on an
%  individual entity of type sal_datapoint should be defined within,
%  whenever possible functions should be coded to accept the most general
%  engine data possible and the method should ensure that the correct 
%  data is supplied to these functions.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    properties
        notes
        dset
    end
    
    methods

	%%%
	%%% constructor function
	%%%

        function dpoint = sal_datapoint(varargin)
	    % read from file
            if length(varargin) == 1
                fname = varargin{1};
            
                %%% file setup
                fid = fopen(fname,'r','b'); % open file
                fseek(fid,0,1);             % seek to eof
                eofloc = ftell(fid);        % store eof location to eofloc
                fseek(fid,0,-1);            % seek to bof
                
                %%% read notes
                notes  = lvb_readarr(fid,1,@lvb_readnotes);
                for i = 1:size(notes,1)
                    eval(['dpoint.notes.' notes{i,2} ' = sal_datanote(notes(i,:));'])
                end
                
                %%% read datasets
                dpoint.dset = sal_dataset.empty(1,0);
                i = 1;
                while ftell(fid) ~= eofloc
                    dpoint.dset(i) = sal_dataset(fid);
                    i = i+1;
                end
                
                fclose(fid);
	    % assign properties form arguments
            else
                notes = varargin{1};
                dpoint.dset  = varargin{2};
                for i = 1:length(notes)
                    eval(['dpoint.notes.' notes(i).varname ' = notes(i);'])
                end
            end
                
            
        end
        
        %%%
        %%% alias functions (search and filtering functions)
        %%%
        
        %%% getdata - find data by sampling type and var name, return data
        function data = getdata(dpoint, dsamp, dname)
            dset_ind = find(strcmp(dsamp,[dpoint.dset(:).sampling]));
            data_ind = find(strcmp(dname,{dpoint.dset(dset_ind).chan(:).varname}));
            data = dpoint.dset(dset_ind).chan(data_ind).data;
        end
        
        %%% getdatac - find data by sampling type and var name, return data as col
        function data = getdatac(dpoint, dsamp, dname)
            dset_ind = find(strcmp(dsamp,[dpoint.dset(:).sampling]));
            data_ind = find(strcmp(dname,{dpoint.dset(dset_ind).chan(:).varname}));
            data = dpoint.dset(dset_ind).chan(data_ind).data(:);
        end
        
        %%% listdata - list available data for a given sampling type
        function list = listdata(dpoint, dsamp)
            dset_ind = strcmp(dsamp,[dpoint.dset(:).sampling]);
            list     = {dpoint.dset(dset_ind).chan(:).varname};
        end
	
	    %%% listsets - list the types of sampling saved in this datapoint
	    function list = listsets(dpoint)
	        for i = 1:length(dpoint.dset)
		        list{i} = dpoint.dset(i).sampling{:};
	        end
        end

	%%%
	%%% data reduction functions 
	%%%
        
        %%% calculate brake fuel conversion efficiency 
        function eff = bfce(dpoint)
            tau_b   = mean(dpoint.getdata('4/CAD','tau_b'));
            fuel_p  = mean(dpoint.getdata('4/CAD','prroh_w'));
            fuel_pw = mean(dpoint.getdata('4/CAD','ti_l'));
            
            W         = tau_b*4*pi;
            [mf, LHV] = sal_fuelinj(fuel_p,fuel_pw,'HF0437');
            
            eff       = mean(W/4./(mf*LHV));
        end
        
        %%% calculate indicated fuel conversion efficiency
        function [eff_g, eff_n] = ifce(dpoint)
            cyl1p   = dpoint.getdata('4/CAD','cyl1p');
            r1map   = dpoint.getdata('4/CAD','r1map');
            ca      = dpoint.getdata('4/CAD','theta');
            fuel_p  = mean(dpoint.getdata('4/CAD','prroh_w'));
            fuel_pw = mean(dpoint.getdata('4/CAD','ti_l'));
            
            [mf, LHV] = sal_fuelinj(fuel_p,fuel_pw,'HF0437');
            
            cyl1p          = sal_peg(cyl1p,r1map);
            [~, dv, vd]    = sal_cylv(ca);
            [gimep, nimep] = sal_mep(cyl1p, dv, vd);
            
            %eff_g = mean(gimep*10^5*vd./(mf*LHV));
            %eff_n = mean(nimep*10^5*vd./(mf*LHV));
            eff_g = gimep*10^5*vd./(mf*LHV);
            eff_n = nimep*10^5*vd./(mf*LHV);
            
        end
        
        
        %%% calculate heat release statistics
        function [ca10, ca50, ca90] = hrstat(dpoint)
            ca    = dpoint.getdata('4/CAD','theta');
            cyl1p = dpoint.getdata('4/CAD','cyl1p');
            r1map = dpoint.getdata('4/CAD','r1map');
            spk   = dpoint.notes.theta_spk.value;
            
            
            cyl_v = sal_cylv(ca(:,1));
            cyl1p = sal_peg(cyl1p,r1map);
            
            ca10 = [];
            ca50 = [];
            ca90 = [];
            for i = 1:length(ca(1,:))
                [mfb(:,i), cad10, cad50, cad90] = sal_mfb(cyl1p(:,i),cyl_v,spk,'debug');
                %plot(mfb),hold on
                ca10 = [ca10 cad10];
                ca50 = [ca50 cad50];
                ca90 = [ca90 cad90];
            end
            %ca10 = diff(mean(mfb'))/(1/4);
            %plot(ca10)
            %ca10 = mean(cad10);
            %ca50 = mean(cad50);
            %ca90 = mean(cad90);
        end
        
        %%% calculate meps
        function [gimep, nimep] = mep(dpoint)
            cyl1p   = dpoint.getdata('4/CAD','cyl1p');
            r1map   = dpoint.getdata('4/CAD','map');
            ca      = dpoint.getdata('4/CAD','theta');
            
            cyl1p          = sal_peg(cyl1p,r1map);
            [~, dv, vd]    = sal_cylv(ca);
            [gimep, nimep] = sal_mep(cyl1p, dv, vd);
        end
        
        %%% find actual cycle closest to mean cycle
        function [ind, cyl1p] = meanrealcycle(dpoint)
            cyl1p  = dpoint.getdata('4/CAD','cyl1p');
            r1map  = dpoint.getdata('4/CAD','map');
            
            cyl1p      = sal_peg(cyl1p,r1map);
            cyl1p_mean = mean(cyl1p,2)*ones(1,length(cyl1p(1,:)));
            
            rmserr      = sqrt(sum((cyl1p-cyl1p_mean).^2,1)/length(cyl1p(:,1)));
            [~,ind]     = min(rmserr);
            cyl1p       = cyl1p(:,ind);
        end
        
        %%% compute mean knocking cycle (under development)
        function [cyl_p, theta_knock, param, param2] = meanknock(dpoint)
            cyl3p = dpoint.getdata('100000Hz','cyl3p');
            di    = dpoint.getdata('100000Hz','di');
            map   = dpoint.getdata('100000Hz','map');
            ca    = dpoint.getdata('4/CAD','theta');
            spk   = dpoint.notes.theta_spk.value;
            bdc   = sal_extractdi(di,3);
            
            cyl3p = sal_cyclify(cyl3p,bdc);
            map   = sal_cyclify(map,bdc);
            
            knk_cycles = [];
            knk_map    = [];
            knk_ca     = [];
            param      = [];
            param2     = [];
            for i = 1:length(cyl3p)
                [knk, knkCA] = sal_knockchk(cyl3p{i},1);
                if(knk)
                    knk_cycles = [knk_cycles, interp1(linspace(0,720,length(cyl3p{i})),cyl3p{i},ca(:,1))];
                    knk_map    = [knk_map, interp1(linspace(0,720,length(map{i})),map{i},ca(:,1))];
                    knk_ca     = [knk_ca, knkCA];
                    
                    
                    %param2      = [param2, max(cyl3p{i})]; % max cylp
                    %param2      = [param2, mean(map{i})]; % mean map
                    %param2      = [param2, mean(map{i}(1:30))]; %pressure at ivc 
                        temp3 = interp1(linspace(0,720,length(cyl3p{i})),cyl3p{i},ca(:,1));
                        temp3 = circshift(temp3,-length(temp3)/4);
                        cyl_v = sal_cylv(ca(:,1));
                        [mfb, cad10, cad50, cad90] = sal_mfb(temp3,cyl_v,40,20,spk);
                        %plot(mfb),hold on
%                         param2       = [param2, cad90-180];
                    %param2 = [param2, knk];
                    param2 = [param2, mfb(round(knkCA*4-1))];
                        temp = interp1(linspace(0,720,length(cyl3p{i})),cyl3p{i},ca(:,1));
                        temp = circshift(temp,-length(temp)/4);
                        temp2 = interp1(linspace(0,720,length(cyl3p{i})),map{i},ca(:,1));
                        temp2 = circshift(temp2,-length(temp2)/4);
                        temp  = sal_peg(temp,temp2);
                        param = [param, temp];
                end
            end
            
            cyl_p = mean(knk_cycles,2);
            cyl_p = circshift(cyl_p,-length(cyl_p)/4);
            map   = mean(knk_map,2);
            cyl_p = sal_peg(cyl_p,map);
            
            theta_knock = knk_ca;

            
            % diagnostics
            %figure,plot(ca(:,1),cyl_p,'-b',theta_knock,interp1(ca(:,1),cyl_p,theta_knock),'or')
            %figure,plot(ca(:,1),map)

            
        end
        
        
        %%% is the operating point knocking
        function isknk = isknocking(dpoint)
            cyl3p = dpoint.getdata('100000Hz','cyl3p');
            bdc   = dpoint.getdata('100000Hz','di');
            
            bdc   = sal_extractdi(bdc,3);
            cyl3p = sal_cyclify(cyl3p,bdc);
            
            % count number of knocking cycles in dataset
            knking=0;
            for i = 1:length(cyl3p)
                if(sal_knockchk(cyl3p{i},1))
                    knking = knking+1;
                end
            end
            
            % check probability of knock is greater than threshold (10%)
            if( knking/length(cyl3p) > 0.1 )
                isknk = 1;
            else
                isknk = 0;
            end
        end
        
        %%% create p-v diagram of mean (no args) or specific cycles
        function pvplot(dpoint, varargin)
            cyl1p   = dpoint.getdata('4/CAD','cyl1p');
            r1map   = dpoint.getdata('4/CAD','r1map');
            ca      = dpoint.getdata('4/CAD','theta');
            
            cyl1p = sal_peg(cyl1p,r1map);
            
            if (nargin == 2)
                cyl1p = cyl1p(:,varargin{1});
            else
                cyl1p = mean(cyl1p,2);
            end
            
            cyl1v = sal_cylv(ca);
            
            % plot mean or specific cycles on p-v diagram
            loglog(cyl1v(:,length(cyl1p(1,:))),cyl1p),hold on
            xlabel('Cylinder Volume, v [m^3]'),ylabel('Cylinder Pressure, p [bar]')
        end
    end
end
