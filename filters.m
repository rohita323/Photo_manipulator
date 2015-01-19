my_image = imread('lena.jpg');
subplot(1,2,1);
imshow(my_image);
subplot(1,2,2);
imshow(imfilter(my_image,fspecial('gaussian')));

%gaussian, sobel, prewitt, laplacian, log, average, unsharp, disk, motion