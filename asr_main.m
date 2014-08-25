% Main Program
%
% Face Recognition by Adaptive Sparse Representations
% (c) Domingo Mery - PUC, 2013



function p = asr_main(stbase,options)


% input 
% stbase              % 'orl', 'cas', 'yale', 'rr'
% options.k           % number of classes
% options.n           % number of images per class
% options.occlusion   % amount of occlusion
% options.distortion  % amount of distorion

if ~isfield(options,'occlusion');
    options.occlusion = 0;
end

if ~isfield(options,'distortion');
    options.distortion = 0;
end

if ~isfield(options, 'rotation');
    options.rotation = 0;
end



%%%%%%%%%%%%%%%%%%
% 1. DEFINITIONS
%%%%%%%%%%%%%%%%%%

close all; warning('off','all')

% images
[f,op]         = asr_images(stbase);                % 'orl', 'cas', 'yale', 'rr'
 
op.k           = options.k;                         % number of classes
op.n           = options.n;                         % number of images per class
op.k           = min([op.k f.imgmax]);              % number of classes <= number of images
op.occlusion   = 0;                                 % zero occlusion for training images
op.distortion  = 0;                                 % zero distrortion for training images
op.rotation    = 0;                                 % zero rotation for training images

op.nz          = 32;                                % size of blocks when calculating sharpness

% patches
siftExtraction = options.siftExtraction;            % weather use random patches or sift extraction method
op.useSiftDescriptor = options.useSiftDescriptor;    % weather usr sift descriptor or patch
if isfield(options,'HOG')
    op.HOG = options.HOG;                               %weather use HOG or not
else
    op.HOG = false;
end
op.m           = options.m;                               % number of patches per image
op.alpha       = 0.1;                               % weight for coordinates in description
op.w           = options.w;                                % pacth size (wxw) pixels
op.a           = op.w;                              % patch's heigh
op.b           = op.w;                              % patch's width
op.ez          = op.a*op.b;                         % number of pixels
op.Q           = options.Q;                                % number of father clusters
op.R           = options.R;                                % number of child clusters
op.ez0         = 1;                                 % 1 includes descriptor and location, ez+1 includes location only
op.s           = 300;                               % number of selected test patches
op.sub         = 1;                                 % subsampling for kd structures (see asr_modell and asr_distance)

op.cosang      = options.cosang;                    % cos angle in scalar product

% sparse representation
op.dictionary  = 1;                                 % 1: kmeans, 0: ksvd
op.Tdata       = 2;
op.dictsize    = op.R;
op.father      = 0;                                 % testing patch is similar to (1) father or (0) child
op.iternum     = 30;
op.memusage    = 'high';
op.T           = 20;                                % number of coefficients ~= 0
op.scqth       = 0.2;                               % threshold for selected patches by testing
op.dD          = Bds_labels(op.R*ones(op.k,1));
op.scith       = 0;                                 % SCI threshold for SCR classification

% general
if ~isfield(options,'show');
    op.show    = 1;                      % display results
else
    op.show    = options.show;                      % display results
end

% labels
dall           = Bds_labels(op.n*ones(op.k,1));     % labels of all images (k subjects with n images per subject)

op.proportion = options.proportion;
%[itrain,itest] = Bds_ixstratify(dall,(op.n-1)/op.n);% indices for learning and for testing (1-1/n training, 1/n testing)
[itrain,itest] = Bds_ixstratify(dall,op.proportion);% indices for learning and for testing (1-1/n training, 1/n testing)


op.itest       = itest;
op.ntest       = length(itest);
op.dtest       = dall(itest);                       % labels of testing data

op.ix          = itrain;
op.uninorm     = 1;

dtrain         = Bds_labels(op.m*op.n*ones(op.k,1)); % ideal class, k subjects, nxm patches per person
ii             = asr_itfull(itest,op.m);
dtrain(ii,:)   = [];


%%%%%%%%%%%%%%%%%%%
% IMAGE ACQUISITION
%%%%%%%%%%%%%%%%%%%

f              = asr_imgsel(f,op);                   % selected images after shaprness evaluation (if any)
f              = asr_showimages(f,op);               % display all images and show in yellow the test images

%%%%%%%%%%%%%%%%%%%
% DESCRIPTION
%%%%%%%%%%%%%%%%%%%
if siftExtraction
    [z,xy]         = expatches(f,op);
else
    [z,xy]         = asr_expatches(f,op);
end


Ytrain         = [z op.alpha*xy];

%%%%%%%%%%%%%%%%%%%
% MODELLING
%%%%%%%%%%%%%%%%%%%

[YP,YC]        = asr_modell(Ytrain,dtrain,op);       % YP: Parent clusters (Q clusters for each class)
                                                     % YC: Child clusters  (R clusters for each father cluster)

%%%%%%%%%%%%%%%%
% TESTING
%%%%%%%%%%%%%%%%

disp('testing')

tic

% extracting patches for testing
op.ix          = itest;
op.occlusion   = options.occlusion;
op.distortion  = options.distortion;
op.rotation    = options.rotation;

if siftExtraction
    [zt,op.xyt]    = expatches(f,op);
    if op.useSiftDescriptor
        op.ez = 128;
    end
else
    [zt,op.xyt]    = asr_expatches(f,op);
end

Ytest          = [zt op.alpha*op.xyt];                  % m patches per each testing image

% computing distances to clusters
op.show        = 0;
[D,S]          = asr_dist(Ytest(:,op.ez0:op.ez+2),YC,YP,op);

% classification
op.show        = options.show;
[ds,vt]        = asr_testing(f,Ytest,YC,D,S,op);

% performance evaluation
p              = asr_eval(f,ds,itest,dall,vt,op);

