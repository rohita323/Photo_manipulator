gray = imread('png-gray.png');

[r,c,k] = size(gray);
RGB = zeros([r,c,3]);

for i = 1 : r
    for j = 1: c
        RGB(i,j,3) = gray(i,j) ;
        RGB(i,j,2) = gray(i,j);
        RGB(i,j,1) = gray(i,j);       

    end
end
imshow(RGB);