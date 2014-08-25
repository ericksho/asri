function notPatches = notClassPatchExtraction()

%% options
trainPath = '/Users/ericksho/Documents/UC/2-2013/tesis/xr/train/';
fullPath = '/Users/ericksho/Documents/UC/2-2013/tesis/xr/full/';

mt = 600;
mf = 6000;
pw = 32;

invariant = true;

% parameter of the optimization procedure are chosen
param.L=20; % not more than 20 non-zeros coefficients (default: min(size(D,1),size(D,2)))
param.lambda=0.15; % not more than 20 non-zeros coefficients
param.numThreads=-1; % number of processors/cores to use; the default choice is -1
                    % and uses all the cores of the machine
param.mode=2;       % penalized formulation

%% leer patches en train
count = 1;
d = [];
trainPatches = [];
folders = dir2(trainPath);
for i = 1:numel(folders)
    files = dir2([trainPath folders(i).name]);
    for j = 1:numel(files)
        I = imread([trainPath folders(i).name '/' files(j).name]);
        if invariant
            [patches ~] = asri_getPatches(I, mt, pw);
        else
            [patches ~] = getPatches(I, mt, pw, false);
        end
        trainPatches = [trainPatches' patches']';
        d(count) = i;
        count = count + 1;
    end
end

%% leer patches de la imagen completa
count = 1;
fullPatches = [];
files = dir2(fullPath);
for i = 1:numel(folders)
    I = imread([fullPath files(i).name]);
    if invariant
            [patches ~] = asri_getPatches(I, mt, pw);
        else
            [patches ~] = getPatches(I, mt, pw, false);
        end
    fullPatches = [fullPatches' patches']';
    count = count + 1;
end

%% construir un diccionario con los patches de train
D = [];
for i = 1:max(d)
    D = [D' trainPatches(d==i,:)']';
end
%% Calculamos el sci de cada uno

for i = 1:size(fullPatches,1)
   y = fullPatches(i,:);
   x = full(mexLasso(y',D',param))';
   
   for j = 1:max(d)
       dx = x.*(d==j);
       delta(j) = sum(dx~=0);
   end
   k = max(d);
   sci(i) = (k*max(delta)/sum(x~=0)-1)/(k-1);
end
    
%% filtramos por umbral

idx = sci < 0.4; %1 es ideal, asi que escogemos los mas bajos, aquellos que no pueden representarse con una sola clase

%% guardamos aquellos que seran los no clase
nonClassPatches = fullPatches(idx,:);

if invariant
    save('filterInvariant.mat');
else
    save('filterRandom.mat');
end


