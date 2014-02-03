% read in string
function strout = lvb_readstr(fid,n)
strout{n} = [];
for i = 1:n
    strlen    = fread(fid,1,'*int32');       % length in bytes
    strout{i} = fread(fid,strlen,'*char')';  % read strlen chars
end
end
