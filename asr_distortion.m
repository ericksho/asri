function J = asr_distortion(I,b)
m1 = [1  1 110 110 
      1 90   1  90 
      1  1   1  1];
  
rr = b*(rand(2,4)-0.5);

m2 = [m1(1:2,:) + rr; 1 1 1 1];

Hs = Bmv_homographySVD(m1,m2);

J = Bmv_projective2D(I,Hs,[110 90],0);


