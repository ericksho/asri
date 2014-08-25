function f = asr_showimages(f,options)

if options.show
    fig1 = figure(1);clf
    set(fig1,'OuterPosition',[800,400,400,700]);
    imshow(f.II,[]);
    hold on
    
    if isfield(options,'itest')
        itest = options.itest;
        h     = f.h;
        w     = f.w;
        ntest = options.ntest;
        sxy = zeros(ntest,4);
        for i=1:ntest
            j = itest(i)-1;
            ii = fix(j/options.n);
            jj = j-ii*options.n;
            y1 = ii*h+1;y2=y1+h+1;
            x1 = jj*w+1;x2=x1+w+1;
            plot([x1 x2 x2 x1 x1],[y1 y1 y2 y2 y1],'y');
            sxy(i,:) = [x1 x2 y1 y2];
        end
        f.sxy = sxy;
    end
end
