function     [Y,ixo] = expatches(f,options)

pw    = options.w;
ix   = options.ix;
m    = options.m;
a    = options.a;
b    = options.b;
show = options.show;

if ~isfield(options,'distortion') % border not considered
    distortion = 0;
else
    distortion    = options.distortion;
end

if ~isfield(options,'occlusion') % border not considered
    occ = 0;
else
    occ    = options.occlusion;
end

if ~isfield(options,'rotation') %border not considered
    rotation = 0;
else
    rotation = options.rotation;
end


if ~isfield(options,'border') % border not considered
    border = 0;
else
    border    = options.border;
end

if ~isfield(options,'triggs') % tan-triggs normalization
    triggs = 0;
else
    triggs    = options.triggs;
end


if ~isfield(options,'uninorm') % border not considered
    uninorm = 0;
else
    uninorm    = options.uninorm;
end

N = length(ix);
I = asr_imgload(f,1);
[h,w] = size(I);

U = asr_LUTpatches(h,w,a,b);

if show
    ff = Bio_statusbar('Extracting features');
    fig2 = figure(2);
end

if options.useSiftDescriptor
    Y = zeros(N*m,128);
    f = rmfield(f,'resize');
else
    Y = zeros(N*m,a*b);
end
ixo = zeros(N*m,2);
for i = 1:N
    ip = indices(i,m);
    I         = asr_imgload(f,ix(i));
    
    % I = imfilter(I,ones(5,5)/25);
    if triggs==1
        I = tantriggs(I);
    end
    if distortion>0
            I           = asr_distortion(I,distortion);
    end
    if occ>0
        x1 = randi(size(I,1)-occ,1);
        y1 = randi(size(I,2)-occ,1);
        I(x1:x1+occ-1,y1:y1+occ-1) = 0;
    end
    if rotation ~= 0
        I = imrotate(I,rotation,'bilinear','crop');
    end
    if show
        ff        = Bio_statusbar(i/N,ff);
        imshow(I,[]);pause(0)
    end
    if std2(I)<1e-12
        fprintf('check image %d in directory %s\n',i,f.path)
        error('Image not found...')
    end
    
    if options.useSiftDescriptor
        [patches xy] = asri_getSift(I, m);
    else
        %[patches xy] = getPatches(I, m, pw);

        [patches xy] = asri_getPatches(I, m, pw);
    end
    
    Y = [ Y' patches']';
    ixo = [ixo' xy']'; 
end

%ixo = ixo+ones(N*m,1)/2*[a b];
ixo = ixo+ones(size(ixo,1),1)/2*[a b];
if show
    delete(ff)
    close(fig2);
end
if uninorm==1
    Y         = asr_uninorm(Y); % normalization
end

end