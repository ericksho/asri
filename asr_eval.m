function p = asr_eval(f,ds,it,dall,vt,options)
show = options.show;
t = toc;
p = Bev_performance(ds,options.dtest);
if and(p<1,show==1)
    ii = find(ds~=options.dtest);
    JJ = [];
    for i=1:length(ii)
        I = [];
        I = asr_imgload(f,it(ii(i)));
        I = [I 256*ones(size(I,1),5)];
        jj = find(dall==ds(ii(i)));
        for j=1:options.n
            I = [I asr_imgload(f,jj(j))];
        end
        JJ = [JJ;I];
    end
    figure(3)
    imshow(imresize(JJ,0.5),[])
end

fprintf('>     accuracy = %7.4f\n',p);
fprintf('> testing time = %7.4f sec/face\n',t/options.ntest);

show = false; %% this isn't working for multitest, and it's not indispensable for algorithm
if show
    figure(4)
    asr_showconfusion(vt./(repmat(sum(vt,2),[1 options.k])))
end
