clt
clc

tic
nPatch = 32;
nPatches = 600;
I = imread('Caltech4/calt_001_001.png');
I = single(I);
f = vl_sift(I) ;
[n,m] = size(I);

K = size(f,2);

magnif = 3.0 ;
y = [-2 -2 ; 2 2];
x = y';

imshow(I,[]), hold on

it=1;
%%
k=1;
while it <= nPatches && k <= K
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
        xy(it,:) = [xall(1) yall(1)];

        xmin = min(xall(:));
        ymin = min(yall(:));
        xmax = max(xall(:));
        ymax = max(yall(:));
        
        w = xmax - xmin;
        h = ymax-ymin;
        I2 = imcrop(I,[xmin ymin w h]);
        xall2 = xall(:)-xmin+1;
        yall2 = yall(:)-ymin+1;

        %%
        x1 = xall2(1); y1 = yall2(1);
        x2 = xall2(2); y2 = yall2(2);
        
        x3 = xall2(3); y3 = yall2(3);
        x4 = xall2(4); y4 = yall2(4);
        
        [n m] = size(I2);
        
        It = I2;
        for i = 1:n
            for j = 1:m                
                if( (i - y1 - (y2-y1)/(x2-x1)*(j-x1) < 0 ) ||  (i - y2 - (y3-y2)/(x3-x2)*(j-x2) > 0) || (i - y1 - (y4-y1)/(x4-x1)*(j-x1) < 0) || (i - y3 - (y4-y3)/(x4-x3)*(j-x3) > 0))
                    It(i,j) = 0;
                else
                    It(i,j) = 1;
                end
            end
        end
        %%
        
        if( sum(It(:)) < numel(It)/2 )
            It = I2;
            for i = 1:n
                for j = 1:m                
                    if( (i - y1 - (y2-y1)/(x2-x1)*(j-x1) > 0 ) ||  (i - y2 - (y3-y2)/(x3-x2)*(j-x2) > 0) || (i - y1 - (y4-y1)/(x4-x1)*(j-x1) < 0) || (i - y3 - (y4-y3)/(x4-x3)*(j-x3) < 0))
                        It(i,j) = 0;
                    else
                        It(i,j) = 1;
                    end
                end
            end
        end

        figure(3)
        imshow(It,[]);
        hold on
        plot(xall2,yall2,'*b')

      %%
        angle = radtodeg(th);
        Irb = imrotate(It,angle);
        Ir = imrotate(I2,angle);
        
        bb = regionprops(Irb,'BoundingBox');
        
        x1 = bb.BoundingBox(1);
        y1 = bb.BoundingBox(2);
        w = bb.BoundingBox(3);
        h = bb.BoundingBox(4);
        
        Ic = Ir(y1:y1+h-1,x1:x1+w-1);
        patch = imresize(Ic,[nPatch nPatch]);
        
        %%
        it = it + 1;
    end
  
  k = k + 1;
end
toc