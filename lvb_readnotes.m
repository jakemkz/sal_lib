function clsout = lvb_readnotes(fid,n)
clsout{n,5} = [];
for i = 1:n
    clsout(i,1:3) = lvb_readstr(fid,3);
    clsout{i,4}   = lvb_readdbl(fid,1);
    clsout(i,5)   = lvb_readstr(fid,1);
end
end