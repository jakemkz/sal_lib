function strout = lvb_readstr(fid,n)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                         %
%    lvb_readstr - read a string from a labview formatted binary file     %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% lvb_readstr - version 1.0 - Jacob E. McKenzie - modified: 01/04/14
%
% inputs:
%  - fid	[int]    : file identifier for binary file saved by labview
%  - n		[int]    : number of strings to read
%
% output:
%  - strout	[array]  : 1 by n cell array of strings
%
% notes:
%  - Current version contains no error checking. 
%
% example:
%  X = lvb_readstr(4,2);
%    This attempts to read two strings from the file with an identifier of
%    4. The strings are then returned as a 1 by 2 cell vector X.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% initialize string array
strout{n} = [];

% for each string read the length (strlen), then read strlen chars
for i = 1:n
    strlen    = fread(fid,1,'*int32');       % length in bytes
    strout{i} = fread(fid,strlen,'*char')';  % read strlen chars
end

end
