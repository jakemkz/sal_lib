function clsout = lvb_readnotes(fid,n)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                         %
%  lvb_readnotes - read notes cluster from labview formatted binary file  %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% lvb_readnotes - version 1.0 - Jacob E. McKenzie - modified: 01/04/14
%
% inputs:
%  - fid	[int]  : file identifier for binary file saved by labview
%  - n		[int]  : number of notes to read
%
% output:
%  - clsout	[cell] : n by 5 cluster of notes about engine data
%
% notes:
%  - Current version contains no error checking. 
%  - Each note consists of three strings followed by a double and a final 
%    string. In order these entries represent:
%     1) A descriptive name of the note
%     2) A note name that qualifies as a matlab variable
%     3) A description of the note, or the notes content if it is a text note
%     4) A double precision note value
%     5) A string describing the units of the numeric value (4)
%
% example:
%  C = lvb_readnotes(4,8);
%    This attempts to read 8 notes from a data file that has a file
%    identifier of 4. In this case C is an 8 by 5 cluster.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clsout{n,5} = [];
for i = 1:n
    clsout(i,1:3) = lvb_readstr(fid,3);
    clsout{i,4}   = lvb_readdbl(fid,1);
    clsout(i,5)   = lvb_readstr(fid,1);
end

end
