function cyl_p = sal_peg(cyl_p,map)

% assumed firing order 1-3-4-2 with data collection triggered on bdc
% compression of cylinder 1.

[m, ncycle] = size(cyl_p);
nsamp       = m/720;        % number of samples per cad

map    = circshift(map,5*nsamp);
cyl_ps = circshift(cyl_p,5*nsamp);
cyl_p  = cyl_p - ones(m,1)*mean(cyl_ps(1:10*nsamp,:)) + ones(m,1)*mean(map(1:10*nsamp,:));
end

