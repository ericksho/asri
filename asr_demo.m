if false
    dbase = 'caltech4';
    nd = length(dbase);

    options.k = 4; %number of classes
    options.n = 10; %number of set samples
    options.w = 32;
    options.Q = 74;
    options.R = 62;
    options.occlusion = 0;
    options.distortion = 0;

    options.rotation = 15;          %rotation on images, evsp
    options.siftExtraction = true;  %sift path extraction method, evsp
    options.useSiftDescriptor = false;
    options.m = 100; %number of pathces extracted
    options.proportion = 0.9;

    if options.useSiftDescriptor % cos angle in scalar product
        options.cosang      = 0.5; %when use sift                          
    else
        options.cosang      = 0.9; %without sift
    end

    p = asr_main(dbase,options);

else

    dbase = 'orl';
    nd = length(dbase);

    options.k = 4;
    options.n = 10;
    options.occlusion = 0;
    options.distortion = 0;
    options.cosang      = 0.9; %without sift
    options.m = 100; %number of pathces extracted

    options.rotation = 0;          %rotation on images, evsp
    options.siftExtraction = false;  %sift path extraction method, evsp
    options.useSiftDescriptor = false;
    options.proportion = 0.9;

    p = asr_main(dbase,options);
end