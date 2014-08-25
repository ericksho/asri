function [ds,vt] = asr_testing(f,Ytest,YC,D,S,options)

show           = options.show;
ntest          = options.ntest;
m              = options.m;
k              = options.k;
s              = options.s;
R              = options.R;
scqth          = options.scqth;
ez             = options.ez;
Q              = options.Q;
dtest          = options.dtest;
% w              = options.w;

ds             = zeros(ntest,1);
vt             = zeros(ntest,k);
% ix             = options.ix;
% xyt            = options.xyt;
cosang         = options.cosang;


%if show>0
    fig3 = figure(3);
    set(fig3,'OuterPosition',[540,480,200,200])
    b        = Bio_statusbar('testing');
    
%end


if options.father == 0
    Dn = (fix((D-1)/options.R)+1);
    % D1  = D+options.R*(1-Dn);
else
    Dn = D;
end


kk = 1:k;


h0 = (0:R-1)';
h1 = repmat(h0,[1 k]);
h1 = (h1(:));
DDbak = options.dD;
Tbak  = options.T;

for i_t=1:ntest
    t  = (i_t-1)*m;
    dp = zeros(m,1);
    sc = zeros(m,1);
    hh = zeros(m,1);
    p  = 0;
    for j=1:m
        options.ik = (S(t+j,:)>cosang);
        nk = sum(options.ik);
        if nk>0
            ypatch = Ytest(t+j,1:ez);   % patch j of test image i_t
            i0 = ((kk-1)*R*Q+(Dn(t+j,kk)-1)*R+1);
            h2 = repmat(i0,[R 1]);
            Ap = YC(h1+h2(:),1:ez); % dictionary for patch k
            
            iik = repmat(options.ik,[R 1])==1;
            options.dD = DDbak(iik);
            options.T  = round(Tbak*nk/k);
            [dpq,scq] = asr_modsrc(ypatch,Ap(iik,:)',options);
            p = p + 1;
            dp(p) = dpq;
            sc(p) = scq;
            hh(p) = S(t+j,dpq);
        end
        %end
    end
    % ii = find(hh>0.99);
    
    [si,sj] = sort(sc,'descend');
    
    jj = find(si>scqth);
    
    sm = min([length(jj) s]);
    
    % ii = find(sc>0);
    % ds(i_t) = mode(dp(ii));
    % ii = find(sc>0);
    ds(i_t) = mode(dp(sj(jj(1:sm))));
    vt(i_t,:) = hist(dp(sj(jj(1:sm))),1:k);
    if show>0
        ixy = f.sxy(i_t,:);
        if ds(i_t) == dtest(i_t);
            scol = 'g';
        else
            scol = 'r';
        end
        figure(1)
        plot(ixy([1 2 2 1 1]),ixy([3 3 4 4 3]),scol)
    end
        figure(3)
        
        per = Bev_performance(ds(1:i_t),dtest(1:i_t));
        bar(per*100)
        axis([0 2 0 110])
        title(['performance = ' num2str(round(per*100)) '%'])
        b = Bio_statusbar(i_t/ntest,b);
end
%if show>0
    delete(b)
%end


% Codigo para mostrar patches y clusters
%
%             if show==2
%                 figure(4)
%                 clf
%                 II = asr_loadimg(f,ix(i_t));
%                 imshow(II,[]);
%                 hold on
%                 y1 = xyt(t+j,1)-w/2;
%                 x1 = xyt(t+j,2)-w/2;
%                 plot([x1 x1+w x1+w x1 x1],[y1+w y1+w y1 y1 y1+w],'r')
%
%                 figure(5)
%                 x = zeros(w,w);
%                 x(:) = ypatch;
%                 clf;
%                 imshow(x,[])
%                 figure(6)
%                 clf
%                 II = [];
%                 for ii=1:k;
%                     JJ=[];
%                     for jj=1:R;
%                         x(:)=Bim_lin(Ap((ii-1)*20+jj,:));
%                         JJ=[JJ x];
%                     end;
%                     II=[II;JJ];
%                 end;
%                 JJ = [];
%                 for ii=1:k
%                     yy = (ii-1)*w;
%                     xx = (D1(t+j,ii)-1)*w;
%                     %                   plot([xx+1 xx+1 xx+w xx+w xx+1],[yy+1 yy+w yy+w yy+1 yy+1],'g');
%                     JJ = [JJ;II(yy+1:yy+w,xx+1:xx+w)];
%                 end
%                 II = [II zeros(size(II,1),fix(w/4)) JJ];
%                 imshow(II,[])
%                 hold on
%                 for ii=1:k
%                     yy = (ii-1)*w;
%                     xx = (D1(t+j,ii)-1)*w;
%                     plot([xx+1 xx+1 xx+w xx+w xx+1],[yy+1 yy+w yy+w yy+1 yy+1],'g');
%                     JJ = [JJ;II(yy+1:yy+w,xx+1:xx+w)];
%                 end
%                 % enterpause
%             end



