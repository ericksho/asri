%% read patches from training

trainPath = '/Users/ericksho/Documents/UC/2-2013/tesis/xr/train/';
folders = dir2(trainPath);
options = [];
trainPatches = [];
for i = 1:numel(folders)
    classPath = [trainPath folders(i).name '/'];
    disp(['analizando ' folders(i).name])
    images = dir2(classPath);
    for j = 1:numel(images)
        I = imread([classPath images(j).name]);
        disp(['patches desde  ' images(j).name])
        patches = asri_extractPatches(I,options);
        trainPatches = [trainPatches' patches']';
    end
end

%% read patches from testing
testPath = '/Users/ericksho/Documents/UC/2-2013/tesis/xr/train';

%% filter thouse patches that dont belong to patches