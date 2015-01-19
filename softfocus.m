clear all;
close all;
clc;
%% Parameters
strength = 5.0;
radius = 4;
grade = 5;
scale = 0.25;
%% file select
FileName = 'lena.jpg';
PathName = 'C:\Users\Brat\Dropbox\DSAA\Assignment2\';
file = [PathName,FileName];
img = cast(imresize(imread(file),scale),'double');
[r c d] = size(img);
IMG = zeros(r,c,d);
%% Focus spot
h = figure; imshow(cast(img,'uint8'));
[X Y] = getpts(h);
c0 = floor(X(1));
r0 = floor(Y(1));
c_ = max(c0,(c-c0));
r_ = max(r0,(r-r0));
L = sqrt(r_^2 + c_^2);
close(h);
%% Oepration
sigma = double(strength);
mask = gaussianMask(sigma);
[l m] = size(mask);
l = floor(l/2);
m = floor(m/2);
ker = mask(l-3:l+3,m-3:m+3);
ker = ker./(sum(sum(ker)));
frame = zeros(r+6,c+6,d);
frame(4:3+r,4:3+c,:) = img;
for i = 4:r+3
  for j = 4:c+3
    Ln = sqrt((r0-i)^2 + (c0-j)^2);
    f = (L-Ln)./L;
    f = (radius*f^grade);
    if (f>1)
      f=1;
    end
    ker(3,3) = f;
    ker = ker./(sum(sum(ker)));
    mat = frame(i-3:i+3,j-3:j+3,:);
    IMG(i-3,j-3,1) = sum(dot(ker,mat(:,:,1)));
    IMG(i-3,j-3,2) = sum(dot(ker,mat(:,:,2)));
    IMG(i-3,j-3,3) = sum(dot(ker,mat(:,:,3)));
  end
end
imG = cast(IMG,'uint8');
imshow(imG);