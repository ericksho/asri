function [Yz,Yq] = asr_modell(Ytrain,dtrain,options)


Q              = options.Q;
k              = options.k;
R              = options.R;
dict           = options.dictionary;
show           = options.show;
if options.useSiftDescriptor
    ez         = 128;
elseif options.HOG
    ez         = 1984;
else
    ez         = options.ez;
end


par.Tdata      = options.Tdata;
par.dictsize   = options.dictsize;
par.iternum    = options.iternum;
par.memusage   = options.memusage;



Yz = zeros(Q*k,ez+2);
Yq = zeros(R*k*Q,ez);
ik = 0;
if show
    if dict == 1
        ft = Bio_statusbar('modelling');
    else
        ft = Bio_statusbar('ksvd');
    end
end

for i=1:k
    if show
        ft = Bio_statusbar(i/k,ft);
    end
    ii                 = dtrain==i;
    YY                 = Ytrain(ii,:);
    [Ycen,jj]          = vl_kmeans(YY',Q,'Algorithm','Elkan');

    Yz(indices(i,Q),:) = Ycen';
    
    % show01
    for q=1:Q
        ik = ik+1;
        ii = find(jj==q);
        Yi = YY(ii,1:ez);
        
        if length(ii)>R
            if dict==1
                D1 = vl_kmeans(Yi',R,'Algorithm','Elkan');
            else
                par.data = Yi';
                
                D1 = ksvd(par,'');
            end
            CC = Bft_uninorm(D1');
            
        else
            CC = Yi;
        end
        Rc = repmat(CC,[R 1]);
        
        Yq(indices(ik,R),:) = Rc(1:R,:);
        % show02
    end
end
if show
    delete(ft)
end


% if options.father == 1
%     Cxy = Yz(:,ez0:ez+2);
%     NN  = Q;
% else
%     Cxy = Yq(:,ez0:ez);
%     NN = Q*R;
% end
% kd = cell(k); % preallocation of a cell
% for i=1:k
%     x = Cxy(indices(i,NN),1:sub:end)';
%     kd{i} = vl_kdtreebuild(x);
%     kd{i}.x = x;
% end
% 
% 
