function Data = compress(o) 
[r,c,v] = size(o)

w = size (o, 2);

samplesThree = floor(w / 2);
 
ci3 = [];

if (v==3)
    for k=1:3% all color layers: RGB
        for i=1:size(o, 1)% all rows
            rowDCT = dct2(double(o(i,:,k)));
            ci3(i,:,k) = idct(rowDCT(1:samplesThree), w);
        end

    end
end
if (v==1)
    
        for i=1:size(o, 1)% all rows
            rowDCT = dct2(double(o(i,:)));
            ci3(i,:) = idct(rowDCT(1:samplesThree), w);
        end

end

Data = uint8(ci3);