function f = asr_imgsel(f,options)


k    = options.k;
n    = options.n;
smin = options.smin;
z    = options.nz;
show = options.show;
nimg = options.nimg;

N    = length(nimg); % number of available images in database

s       = rand(N,1);
[si,sj] = sort(s);

i     = 0;
j     = 0;

Ti    = zeros(k,1); % selected subjects

Tf    = zeros(k,n); % selected images


if sum(f.ix_database(1:2)=='rr')==2
    load data_rr_sha
end



if show
    ft = Bio_statusbar('sampling faces');
end
II = [];
sh = 10000;

while and(i<k,j<N)
    if show
        ft = Bio_statusbar(i/k,ft);
    end
    j          = j+1;
    indiv      = sj(j);
    
    x          = rand(nimg(indiv),1);
    [xi,xj]    = sort(x);
    a          = 0;
    ok         = 0;
    p          = 0;
    tp         = zeros(1,200);
    
    KK         = zeros(f.h,f.w,200);
    while ok==0
        a = a+1;
        if a<=nimg(indiv) %mientras a sea menor al numero de individuos por clase indiv
            f.ti = indiv;
            f.tf = xj(a);
            I    = asr_imgload(f,1);
            if smin>0
                if SHA(indiv,xj(a)) == 0;
                    sh = asr_sharpness(I,z,z);
                    SHA(indiv,xj(a)) = sh;
                    save data_rr_sha SHA
                    disp('*')
                else
                    sh = SHA(indiv,xj(a));
                end
            end

            if sh > smin
                p = p + 1;
                KK(:,:,p) = I;
                tp(p) = a;
            end
        else
            ok = 1;
        end
        
        if p == n
            
            ok = 1;
        end
    end
    
    JJ = [];
    if p >= n-3
        sp       = rand(n,1);
        [sip,sjp] = sort(sp);
        sjj = sjp(1:n);
        t = tp(sjj);
        for q = 1:n
            JJ = [JJ KK(:,:,sjj(q))];
        end
        i = i+1;
        Ti(i) = indiv;
        Tf(i,:) = t;
        II = [II; JJ];
    end
end

if i<k %no menos de 20 seleccionados
    if show
        delete(ft);
    end
    error('not enough persons were selected')
end

if show
    delete(ft);
end
Ti = repmat(Ti,[1 n])';
f.ti = Ti(:);
Tf = Tf';
f.tf = Tf(:);
f.II = II;
