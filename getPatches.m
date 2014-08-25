%%%%%
%get patches with SIFT
%Erick Svec - 2013
%%%%%
function [patches xy] = getPatches(I, nPatches, patchSize, verbose)
warning off

I = single(I);
[f,d] = vl_sift(I) ;
[n,m] = size(I);
nPatch = patchSize;

patches = zeros(nPatches, nPatch*nPatch);
it = 1;
while it <= nPatches
    if verbose
        figure(1)
        imshow(I,[]);
        hold on;
    end

    perm = randperm(size(f,2)) ;
    sel = perm(1) ;

    if verbose
        h1 = vl_plotframe(f(:,sel)) ;
        h2 = vl_plotframe(f(:,sel)) ;
        set(h1,'color','k','linewidth',3) ;
        set(h2,'color','y','linewidth',2) ;
    end

    [xall,yall]=vl_plotsiftdescriptor2(d(:,sel),f(:,sel)) ;

    [c1,p1] = min(xall);
    [c2,p3] = max(xall);
    [c3,p2] = min(yall);
    [c4,p4] = max(yall);
    
    if(c1 < 1 || c3 < 1 || c2 > m || c4 > n)
        if verbose
            disp('patch cortado, se elimina y busca otro')
        end
    else

        selline = [p1 p2 p3 p4];

        if verbose
            plot(xall(selline), yall(selline),'*r');
        end
        
        %%
        It = I;
        
        y1 = yall(selline(1)); y2 = yall(selline(2));
        x1 = xall(selline(1)); x2 = xall(selline(2));

        y3 = yall(selline(3)); y4 = yall(selline(4));
        x3 = xall(selline(3)); x4 = xall(selline(4));
        
        xy(it,:) = [x1 y1];
        
        for i = 1:n
            for j = 1:m                
                if( (i - y1 - (y2-y1)/(x2-x1)*(j-x1) < 0) ||  (i - y2 - (y3-y2)/(x3-x2)*(j-x2) < 0) || (i - y1 - (y4-y1)/(x4-x1)*(j-x1) > 0) || (i - y3 - (y4-y3)/(x4-x3)*(j-x3) > 0))
                    It(i,j) = 0;
                else
                    It(i,j) = 1;
                end
            end
        end
        
        if verbose
            figure(3)
            imshow(It,[]);
            hold on
            plot(xall(selline), yall(selline),'*r');
            line(xall(selline), yall(selline));
        end
%%
        angle = radtodeg(f(4,sel));
        Irb = imrotate(It,angle);
        Ir = imrotate(I,angle);
        
        bb = regionprops(Irb,'BoundingBox');
        
        x = bb.BoundingBox(1);
        y = bb.BoundingBox(2);
        w = bb.BoundingBox(3);
        h = bb.BoundingBox(4);
        
%%
        Ic = Ir(y:y+h-1,x:x+w-1);
        if verbose
            figure(2)
            imshow(Ic,[]);
        end
        patch = imresize(Ic,[nPatch nPatch]);
        patches(it,:) = patch(:);
        it = it + 1;
        
    end
end

warning on


end