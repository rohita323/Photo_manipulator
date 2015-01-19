function newImage = fisheye(Filename)
[rgbImage,map] = imread(Filename);  %# Read the indexed image
[r,c,k]  = size(rgbImage);
if (k~=3)
    rgbImage = gray2RGB(rgbImage);
end
[r,c,d] = size(rgbImage);        %# Get the image dimensions
nPad = (c-r)/2;                  %# The number of padding rows
rgbImage = cat(1,ones(nPad,c,3),rgbImage,ones(nPad,c,3));  %# Pad with white
options = [c c 2];  %# An array containing the columns, rows, and exponent
tf = maketform('custom',2,2,[],@fisheye_inverse,options);
newImage = imtransform(rgbImage,tf);  %# Transform the image
imshow(newImage);      
end