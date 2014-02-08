function [knocking, knockCA] = sal_knockchk(cyl_p, threshold)

pflt  = sal_hpf(cyl_p);  % filter cylinder pressure
maxKI = max(abs(pflt));  % find maximum knock intensity

if( maxKI > threshold )
    kind = find(abs(pflt) > threshold, 1, 'first');
    knockCA  = 720*kind/(length(pflt)-1) - 180; % compute CA of knock relative to BDC comp
    knocking = 1;
else
    knocking = 0;
    knockCA  = [];
end

end