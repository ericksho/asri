% Classification using Sparse Representation Classification
% Robust Face Recognition via Sparse Representation - Wright (PAMI 2007)
%

function [ds,sci,s] = asr_modsrc(yt,D,op)

T      = op.T;      % sparcity
k      = op.k;      % number of classes 1, 2, ... c
th     = op.scith;  % min accepted value for sci
dtrain = op.dD;     % columns of D for each class


%xt = full(omp(D'*yt',D'*D,T))'; % Sparsity-constrained Orthogonal Matching Pursuit

% parameter of the optimization procedure are chosen
param.L = T; % not more than L non-zeros coefficients
param.eps=0.1; % squared norm of the residual should be less than 0.1
param.numThreads=-1; % number of processors/cores to use; the default choice is -1
                    % and uses all the cores of the machine
                    
xt = full(mexOMP(yt',D,param))';
s1 = sum(abs(xt));
s  = zeros(k,1);
ek = zeros(k,1);
% nk = sum(op.ik);
for i=1:k
    if op.ik(i)==1
        ii = dtrain == i;
        s(i)  = sum(abs(xt(:,ii)));
        Rk    = (yt'-D(:,ii)*xt(:,ii)')';         % residual^2
        ek(i) = sum(Rk.*Rk,2);
    end
end
sci = (k*max(s)/s1-1)/(k-1);
if (sci>=th)
    [~,j] = min(ek(op.ik));
    ds = j;
else
    ds = k+1;
end


