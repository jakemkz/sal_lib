function dblout = lvb_readdbl(fid,n)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                         %
%    lvb_readdbl - read a double from a labview formatted binary file     %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% lvb_readdbl - version 1.0 - Jacob E. McKenzie - modified: 01/04/14
%
% inputs:
%  - fid	[int]    : file identifier for binary file saved by labview
%  - n		[int]    : number of double precision floats to read
%
% output:
%  - dblout	[array]  : 1 by n vector of doubles read from file
%
% notes:
%  - Current version contains no error checking. 
%
% example:
%  A = lvb_readdbl(4,8);
%    This attempts to read 8 double precision floats from the labview
%    formatted binary file with a file identifier of 4. The values are
%    returned as a 1 by 8 vector.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dblout = fread(fid,n,'*double');

end
