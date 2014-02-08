function arrout = lvb_readarr(fid,ndim,readfcn)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                         %
%    lvb_readarr - read an array from a labview formatted binary file     %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% lvb_readarr - version 0.9 - Jacob E. McKenzie - modified: 01/04/14
%
% inputs:
%  - fid	[int]    : file identifier of binary file saved by labview
%  - ndim	[int]    : number of array dimensions (2 or 3)
%  - readfcn    [handle] : function handle of element read function
%
% output:
%  - arrout	[array]  : cell or array of values read from binary file
%
% notes:
%  - Current version contains no error checking. 
%  - In order to use this code the number of dimensions and data type
%    of the array must be known and the file must be cued up to the 
%    beginning of the array descriptor.
%
% example:
%  X = lvb_readarr(4,2,@lvb_readdbl);
%    This attempts to read a two dimensional matrix from the file with an
%    identifier of 4. Each element is read using lvb_readdbl function. 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% read the array size descriptor (number of elements in each dim)
aels   = wrev(fread(fid,ndim,'int32=>double'))';

% read elements and place elements in either a cell or an array
arrout = readfcn(fid,prod(aels));

% permute the array such that it matches the labview orientation
if ndim == 2 
    arrout = reshape(arrout,aels);
    arrout = permute(arrout,[2,1]);
else
    if ndim == 3
        arrout = reshape(arrout,aels);
        arrout = permute(arrout,[2,1,3]);
    end
end

end
