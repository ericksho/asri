% Definition of all images
%
% Face Recognition by Adaptive Sparse Representations
% (c) Domingo Mery - PUC, 2013



function [f,options] = asr_images(ix)

f.ix_database = ix;
multifolder = false;

switch ix
    case 'rr' 
        f.path          = '/Users/domingomery/Dropbox/Mingo/Matlab/images/faces/faces_rr/cropped/';
        f.prefix        = 'face_';
        f.extension     = 'bmp';
        f.imgmax        = 114;
        f.resize        = [110 90];
        options.smin    = 100;
        options.border  = 10;
        options.triggs  = 0;                                 % enhancement after Tan & Triggs
        options.smin    = 90;                                % threshold for sharpness selection
        
    case 'cas' 
        f.path          = '/Users/domingomery/Dropbox/Mingo/Matlab/images/faces/faces_cas/';
        f.prefix        = 'face_';
        f.extension     = 'tif';
        f.imgmax        = 66;
        f.resize        = 1.45;
        f.window        = [ 40 149 30 119 ];
        options.smin    = 0;
        options.border  = 10;
        options.triggs  = 1;                                 % enhancement after Tan & Triggs
        
    case 'yale'
        f.path          = '/Users/domingomery/Dropbox/Mingo/Matlab/images/faces/faces_yale/';
        f.prefix        = 'face_';
        f.extension     = 'png';
        f.imgmax        = 38;
        f.resize        = [110 90];
        options.border  = 0;
        options.smin    = 0;
        options.triggs  = 1;                                 % enhancement after Tan & Triggs
        
    case 'orl'
        f.path          = '/Users/ericksho/Documents/UC/2-2013/tesis/asr/faces_att/';
        f.prefix        = 'face_';
        f.extension     = 'png';
        f.imgmax        = 40;
        f.resize        = [110 90];
        options.boder   = 10;
        f.digits        = 2;
        options.smin    = 0;
        options.triggs  = 0;   % enhancement after Tan & Triggs
        
    case 'caltech4'
        f.path          = '/Users/ericksho/Documents/UC/2-2013/tesis/asr 2/Caltech4/';
        f.prefix        = 'calt_';
        f.extension     = 'png';
        f.imgmax        = 300;
        f.digits        = 3;
        %f.resize        = [110 90];  %%no usamos resize para obtener mas
        %puntos sift
        options.boder   = 0;
        options.smin    = 0;
        options.triggs  = 0;   % enhancement after Tan & Triggs
        
    case 'rx'
        f.path          = '/Users/ericksho/Documents/UC/2-2013/tesis/xraydataset/rx/';
        f.prefix        = 'rx_';
        f.extension     = 'png';
        f.imgmax        = 40;
        f.digits        = 3;
        f.resize        = [100 100];  
        %puntos sift
        options.boder   = 0;
        options.smin    = 0;
        options.triggs  = 0;   % enhancement after Tan & Triggs

    otherwise
        error('Database does not exist.');
end

f.ti = 1;
f.tf = 1;
I         = asr_imgload(f,1);
[f.h,f.w] = size(I); % dimension of the images height x width

sf = ['data_' ix '.mat'];
if ~exist(sf,'file')
    disp('estimating number of images per class...')
    nimg = asr_nimg(f);
    save(sf,'nimg');
else
    x = load(sf);
    nimg = x.nimg;
end
options.nimg = nimg;
    
    
    
    
    


