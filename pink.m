function Data = pink(RGB)
[r,c,k] = size(RGB);
if (k ~= 3)
    return
end
for i = 1 : r
    for j = 1: c
        R = RGB(i,j,1);
        G = RGB(i,j,2);
        B = RGB(i,j,3);
        r = 0.9*R + 0.3*G + 0.7*B;
        g = 0.3*R + 0.2*G + 0.4*B;
        b = 0.3*R + 0.2*G + 0.1*B;
        Data(i,j,1) = r ;
        Data(i,j,2) = g ;
        Data(i,j,3) = b ;
    end
end

end