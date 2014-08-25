%asri_demo

dbase = 'caltech4';
nd = length(dbase);

options.k = 4;
options.n = 50;
options.occlusion = 0;
options.distortion = 0;

perf = zeros(20,4);

for i = 1:20
    options.rotation = 90/i;          %rotation on images, evsp
    disp('*** **** ***');
    options.siftExtraction = false;  %sift path extraction method, evsp    
    fprintf('rot: %d sift: %i \n', options.rotation,options.siftExtraction);
    p = asr_main(dbase,options);

    options.siftExtraction = true;  %sift path extraction method, evsp    
    fprintf('rot: %d sift: %i \n', options.rotation,options.siftExtraction);
    p2 = asr_main(dbase,options);

    perf(i,:) = [options.rotation options.siftExtraction p p2];
end