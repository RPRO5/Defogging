
Im1=imread('Results/canon_air.jpg');
G1=imhist(Im1(:,:,2));
R1=imhist(Im1(:,:,1));
B1=imhist(Im1(:,:,3));
figure, plot(R1,'r'),title('Airlight')
hold on, plot(G1,'g')
plot(B1,'b'), legend(' Red channel','Green channel','Blue channel');
hold off

Im2=imread('Results/canon_veil.jpg');
G=imhist(Im2(:,:,2));
R=imhist(Im2(:,:,1));
B=imhist(Im2(:,:,3));
figure, plot(R,'r'),title('Veil')
hold on, plot(G,'g')
plot(B,'b'), legend(' Red channel','Green channel','Blue channel');
hold off

Im3=imread('Results/canon_combine.jpg');
G=imhist(Im3(:,:,2));
R=imhist(Im3(:,:,1));
B=imhist(Im3(:,:,3));
figure, plot(R,'r'),title('Combined')
hold on, plot(G,'g')
plot(B,'b'), legend(' Red channel','Green channel','Blue channel');
hold off