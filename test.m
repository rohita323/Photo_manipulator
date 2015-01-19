RGB = imread('png-gray.png');
Data = RGB;
[r,c,k] = size(RGB);

if (k~=3)
    RGB = gray2RGB(RGB);
end

figure, imshow(RGB)
for i = 1 : r
    for j = 1: c
        R = RGB(i,j,1);
        G = RGB(i,j,2);
        B = RGB(i,j,3);
        r = double((R * 0.512 + G * 0.801 + B * 0.289));
        g = double((R * 0.312 + G * 0.801 + B * 0.068));
        b = double((R * 0.172 + G * 0.434 + B * 0.031));
        
        Data(i,j,1) = r ;
        Data(i,j,2) = g ;
        Data(i,j,3) = b ;
    end
end
figure,imshow(Data)
