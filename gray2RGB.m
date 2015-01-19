function RGB = gray2RGB(I)
[X, map] = gray2ind(I, 20480);
RGB = ind2rgb(X,map);
end