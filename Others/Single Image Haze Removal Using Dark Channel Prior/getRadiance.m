function J = getRadiance(A,img,tMat)
t0 = 0.1;
J = zeros(size(img));
for ind = 1:3
   J(:,:,ind) = A(ind) + (img(:,:,ind) - A(ind))./max(tMat,t0); 
end
J = J./(max(max(max(J))));


