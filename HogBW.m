function [out] = HogBW(I, cellSize,patchSize)

for i = 1:size(I,1)

    im = double(I(i,:));
    
    im = reshape(im,patchSize,patchSize);

    histos = vl_hog(single(im), cellSize); %from vlfeat

    %histos= featuresBW(im, cellSize); %from Felzenwalds

    [yHistos xHistos nBins]=size(histos);

    out(i,:) = reshape(histos,1,yHistos*xHistos*nBins);
    
end

return;
