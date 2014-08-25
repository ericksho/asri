function Y = asr_readpatches(I,ii,jj,U)
% ii: i values of coordinate i of first pixel of all patches
% jj: j values of coordinate j of first pixel of all patches
% I : grayvalue image
% U : Lookup Table of the indices of the patches computed using LUTpatches
h     = size(I,1);
kk    = (jj-1)*h+ii;
Iv    = I(:);
n     = length(kk);
m     = size(U,2);
Y     = zeros(n,m);
Y(:)  = Iv(U(kk,:));
