% read in double precision float
function dblout = lvb_readdbl(fid,n)
dblout = fread(fid,n,'*double');
end