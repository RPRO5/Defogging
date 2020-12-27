function res2=run_examples(im)
% Gray level example of visibility restoration
% im=double(imread('PISTEB00738S.pgm'))/255.0;
% sv=2*floor(max(size(im))/25)+1;
% % ICCV'2009 paper result (NBPC)
% res=nbpc(im,sv,0.95,-1,1,1.0);
% figure;imshow([im, res],[0,1]);
% % IV'2010 paper result (NBPC+PA)
% res2=nbpcpa(im,sv,0.95,-1,1,1.0,70,200);
% figure;imshow([im, res2],[0,1]);

% Color example of visibility restoration
im=double(im)/255.0;
sv=2*floor(max(size(im))/50)+1;
% ICCV'2009 paper result (NBPC)
% res=nbpc(im,sv,0.95,0.5,1,1.3);
% figure;imshow([im, res],[0,1]);
% IV'2010 paper result (NBPC+PA)

res2=nbpcpa(im,sv,0.95,0.5,1,1.3,205,300);
%figure;imshow([im, res2],[0,1]);




