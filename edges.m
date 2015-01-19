% This demo is known to work with:
%    Matlab Version 7.10.0.499 (R2010a)
%    Image Processing Toolbox Version 7.0 (R2010a)

A = imread('test3.jpg');

% Marr/Hildreth edge detection
% with threshold forced to zero
MH1 = edge(A,'log',0,1.0);
MH2 = edge(A,'log',0,2.0);
MH3 = edge(A,'log',0,3.0);
MH4 = edge(A,'log',0,4.0);

% form mosaic
EFGH = [ MH1 MH2; MH3 MH4];

%% show mosaic in Matlab Figure window
log = figure('Name','Marr/Hildreth: UL: s=1  UR: s=2  BL: s=3 BR: s=4');
iptsetpref('ImshowBorder','tight');
imshow(EFGH,'InitialMagnification',100);

% Canny edge detection
[C1, Ct1] = edge(A,'canny',[],1.0);
[C2, Ct2] = edge(A,'canny',[],2.0);
[C3, Ct3] = edge(A,'canny',[],3.0);
[C4, Ct4] = edge(A,'canny',[],4.0);

% Recompute lowering both automatically computed
% thresholds by fraction k
k = 0.75;
C1 = edge(A,'canny',k*Ct1,1.0);
C2 = edge(A,'canny',k*Ct2,2.0);
C3 = edge(A,'canny',k*Ct3,3.0);
C4 = edge(A,'canny',k*Ct4,4.0);

% form mosaic
ABCD = [ C1 C2; C3 C4 ];

% show mosaic in Matlab Figure window
canny = figure('Name','Canny: UL: s=1  UR: s=2  BL: s=3 BR: s=4');
iptsetpref('ImshowBorder','tight');
imshow(ABCD,'InitialMagnification',100);

% uncomment to write results to file
%imwrite(ABCD,'canny.pbm','pbm');
%imwrite(EFGH,'log.pbm','pbm');
