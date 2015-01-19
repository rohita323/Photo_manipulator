function bw = filegray(RGB)
[r,c,k] = size(RGB);

if (k ==1)
    return;
end
bw = uint8(zeros(r,c));
imshow(RGB);
x = RGB(1,1,1);

for i = 1 : r
    for j = 1: c
        R = RGB(i,j,1);
        G = RGB(i,j,2);
        B = RGB(i,j,3);        
        I = .29 * R + .587 * G + .114 * B ;
        bw(i,j) = I ;
    end
end


end