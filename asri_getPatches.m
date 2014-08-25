%%%%%
%get patches with SIFT
%Erick Svec - 2013
%%%%%
function [patches xy] = asri_getPatches(I, nPatches, patchSize)

I = single(I);
[f,d] = vl_sift(I) ;
[n,m] = size(I);
nPatch = patchSize;
minTexture = 0; %min texture threshold for accepting a patch

K = size(f,2);

magnif = 3.0 ;
y = [-2 -2 ; 2 2];
x = y';

%patches = zeros(nPatches, nPatch*nPatch);

it=1;
%%
k=1;
while it <= nPatches && k <= size(f,2)
    %%
    SBP = magnif * f(3,k) ;
    th=f(4,k) ;
    c=cos(th) ;
    s=sin(th) ;

    xall = SBP*(c*x-s*y)+f(1,k);
    yall = SBP*(s*x+c*y)+f(2,k);

    xall = [xall(1) xall(2) xall(4) xall(3)];
    yall = [yall(1) yall(2) yall(4) yall(3)];
	%%
    if isempty(find(xall < 0)) && isempty(find(yall < 0)) && isempty(find(xall > m)) && isempty(find(yall > n))
        %%
        xmin = min(xall(:));
        ymin = min(yall(:));
        xmax = max(xall(:));
        ymax = max(yall(:));
        w = xmax - xmin;
        h = ymax-ymin;
        xall2 = xall(:)-xmin+1;
        yall2 = yall(:)-ymin+1;
        angle = radtodeg(th);
        Ic = imcrop(I,[xmin ymin w h]);
        Ibw = roipoly(Ic,xall2,yall2);

        Irb = imrotate(Ibw,angle);
        Ir = imrotate(Ic,angle);

        bb = regionprops(Irb,'BoundingBox');

        xbb = bb.BoundingBox(1);
        ybb = bb.BoundingBox(2);
        wbb = bb.BoundingBox(3);
        hbb = bb.BoundingBox(4);

        Ic = Ir(ybb:ybb+hbb-1,xbb:xbb+wbb-1);
        patch = imresize(Ic,[nPatch nPatch]);
        
        if std(patch(:)) > minTexture
            patches(it,:) = patch(:);
            xy(it,:) = [xall(1) yall(1)];

            it = it + 1;
        end
    end
  
    k = k + 1;
end
end