%% parameter tester
%1597
oldTest = false %to test on caltech
%% parameter tester

for i = 1:1
    for j = 1:1
        dbase = 'rx';
        nd = length(dbase);

        options.k = 3;
        options.n = 30;
        options.occlusion = 0;
        options.distortion = 0;
        options.cosang      = 0.15; %without sift 0.6
        options.m = 1000; %number of patches extracted
        options.proportion = 0.4;

        options.rotation = 0;          %rotation on images, evsp
        options.siftExtraction = false;  %sift path extraction method, evsp
        options.useSiftDescriptor = false;
        options.HOG = false;
        options.w = 32; %patch size
        options.show = 0;
        %options.resize = 0.5;
        options.Q = 32;             % number of clusters 32
        options.R = 20;              % number of child clusters 20
        
        p = asr_main(dbase,options);

        P(j) = p;
        OP{j} = options;
    end
    PT{i} = P;
    OPT{i} = OP;
end

for j = 1:3
	for i = 1:500, beep, end
    pause(0.5)
end

if oldTest

    pause

    for i = 1:1
        for j = 1:10
            dbase = 'caltech4';
            nd = length(dbase);

            options.k = 4;
            options.n = 30;
            options.occlusion = 0;
            options.distortion = 0;
            options.cosang      = 0.15; %without sift 0.6
            options.m = 100; %number of pathces extracted
            options.proportion = 0.4;

            options.rotation = 0;          %rotation on images, evsp
            options.siftExtraction = false;  %sift path extraction method, evsp
            options.useSiftDescriptor = false;
            options.HOG = false;
            options.w = 32; %patch size
            options.show = 1;
            %options.resize = 0.5;
            options.Q = 64;             % number of clusters 32
            options.R = 70;              % number of child clusters 20

            p = asr_main(dbase,options);

            P(j) = p;
            OP{j} = options;
        end
        PT{i} = P;
        OPT{i} = OP;
    end

    for j = 1:5
        for i = 1:500, beep, end
        pause(0.5)
    end
end