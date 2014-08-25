%%%%%
%get patches with SIFT
%Erick Svec - 2013
%%%%%
function [patches xy] = asri_getSift(I, nPatches)

I = single(I);
[f,d] = vl_sift(I) ;
[n,m] = size(I);

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
        patches(it,:) = d(:,1)';
        xy(it,:) = [f(1,k) f(2,k)];
        
        it = it + 1;
    end
  
    k = k + 1;
end

end