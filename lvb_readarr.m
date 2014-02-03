function arrout = lvb_readarr(fid,ndim,readfcn)
aels   = wrev(fread(fid,ndim,'int32=>double'))';

% place elements in either a cell or an array
arrout = readfcn(fid,prod(aels));

% permute the arrays such that they match labview orientation
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