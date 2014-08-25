function [s,t] = asr_sharpness(I,ni,nj)
%
% s = sharpness of an image I = mean of sharpness of all blocks of ni x nj pixels
% t = vector containing the sharpness of all blocks.
%
% D.Mery, Oct. 2013


[N,M] = size(I);
I     = double(I);
Gx    = conv2(I,[-1 0 1],'same');       % gradient x
Gy    = conv2(I,[-1 0 1]','same');      % gradient y
ii    = 1:ni:N-ni;
jj    = 1:nj:M-nj;
t     = zeros(length(ii)*length(jj),1); % number of blocks

% noise estimation
Im    = medfilt2(I,[3 3]);J=abs(I-Im);
r     = median(J(:));

k     = 0;
for i=1:ni:N-ni
    for j=1:nj:M-nj
        k = k+1;
        Px = Gx(i:i+ni-1,j:j+nj-1);
        Py = Gy(i:i+ni-1,j:j+nj-1);
        G  = [Px(:) Py(:)];
        [U,S,V] = svd(G);
        t(k) = S(1,1)/(1+r^2);
    end
end
s = mean(t);
        