function [D,S] = asr_dist(Ytest,YC,YP,options)

Q              = options.Q;
R              = options.R;
ez             = options.ez;
ez0            = options.ez0;


if ~isfield(options,'sub')
    sub = 1;
else
    sub            = options.sub;
end


if options.father == 1
    ii = 1:options.ez+2;
else
    ii = 1:options.ez;
end


k = options.k;
m = options.m;
ntest = options.ntest;

ft = Bio_statusbar('distances');


if options.father == 1
    Cxy = YP(:,ez0:ez+2);
    NN  = Q;
else
    Cxy = YC(:,ez0:ez);
    NN = Q*R;
end

D = zeros(ntest*m,k);
S = zeros(ntest*m,k);
%for i = 1:ntest
y = Ytest(:,ii(1:sub:end));
for i = 1:k
    ft      = Bio_statusbar(i/k,ft);
    X       = y*Cxy(indices(i,NN),1:sub:end)';
    [j2,i2] =max(X,[],2);
    D(:,i)  = i2';
    S(:,i)  = j2';
end
%if options.father == 0;
%    D = (fix((D-1)/options.R)+1);
%end
delete(ft);
