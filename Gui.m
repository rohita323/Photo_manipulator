

function varargout = Gui(varargin)
%jFrame = get(handle(gcf),'JavaFrame')
%jFrame.setMaximized(false); 
% GUI MATLAB code for Gui.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
%
%      GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI.M with the given input arguments.
%
%      GUI('Property','Value',...) creates a new GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES
%

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Gui_OpeningFcn, ...
                   'gui_OutputFcn',  @Gui_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before Gui is made visible.
function Gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Gui (see VARARGIN)

% Choose default command line output for Gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
global Filename Pathname ;
Filename = '';
Pathname = '';
imshow('default.jpg')


% UIWAIT makes Gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure






varargout{1} = handles.output;

% --- Executes when figure1 is resized.
function figure1_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in SoftFocus.
function SoftFocus_Callback(hObject, eventdata, handles)
%% Parameters
strength = 20.0;
radius = 16;
grade = 20;
scale = 1.0;
global Filename Pathname Data;
if(strcmp(Filename,'')==1)
   h = msgbox('No image Selected','Error','error');
   return
end
file = [Pathname,'./tmp/effects.jpg'];
x = imread('./tmp/effects.jpg');
[r c k] = size(x);
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
    if(k > 1)
        IMG(i-3,j-3,2) = sum(dot(ker,mat(:,:,2)));
        IMG(i-3,j-3,3) = sum(dot(ker,mat(:,:,3)));
    end
  end
end
imG = cast(IMG,'uint8');
imwrite(imG,'./tmp/focus.jpg');
imshow(imG);

% --- Executes on button press in ShadowFocus.
function ShadowFocus_Callback(hObject, eventdata, handles)


radius = 2;
grade = 2;
scale = 0.5;
%% File Select
global Filename Pathname Data;
if(strcmp(Filename,'')==1)
   h = msgbox('No image Selected','Error','error');
   return
end
file = [Pathname,'./tmp/effects.jpg'];
img = cast(imresize(imread(file),scale),'double');
%% Focal point and processing parameters
[r c d] = size(img);
IMG = zeros(r,c,d);
h = figure; imshow(cast(img,'uint8'));
[X Y] = getpts(h);
c0 = floor(X(1));
r0 = floor(Y(1));
c_ = max(c0,(c-c0));
r_ = max(r0,(r-r0));
L = sqrt(r_^2 + c_^2);
close(h);

%% Processing
for i = 1:r
  for j = 1:c
    Ln = sqrt((r0-i)^2 + (c0-j)^2);
    f = (L-Ln)./L;
    f = (radius*f^grade);
    if(f>1)
      f=1;
    end
    IMG(i,j,:) = f*img(i,j,:);
  end
end
%% Display
imG = cast(IMG,'uint8');
imwrite(imG,'./tmp/focus.jpg');
imshow(imG);


% --- Executes on button press in Fisheye.
function Fisheye_Callback(hObject, eventdata, handles)
% hObject    handle to Fisheye (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Filename;
if(strcmp(Filename,'')==1)
   h = msgbox('No image Selected','Error','error');
   return
end

imwrite(fisheye(Filename),'./tmp/fisheye.jpg');


% --- Executes on button press in Gaussian.
function Gaussian_Callback(hObject, eventdata, handles)
global Filename Pathname Data;
if(strcmp(Filename,'')==1)
   h = msgbox('No image Selected','Error','error');
   return
end
my_image = imread('./tmp/filter.jpg');
e = imfilter(my_image,fspecial('gaussian'));
imwrite(e,'./tmp/effects.jpg')
imwrite(e,'./tmp/focus.jpg');
imshow(e);


% --- Executes on button press in Avg.
function Avg_Callback(hObject, eventdata, handles)
global Filename Pathname Data;
if(strcmp(Filename,'')==1)
   h = msgbox('No image Selected','Error','error');
   return
end
my_image = imread('./tmp/filter.jpg');
e = imfilter(my_image,fspecial('average'));
imwrite(e,'./tmp/effects.jpg')
imwrite(e,'./tmp/focus.jpg');
imshow(e);


% --- Executes on button press in Prewitt.
function Prewitt_Callback(hObject, eventdata, handles)
global Filename Pathname Data;
if(strcmp(Filename,'')==1)
   h = msgbox('No image Selected','Error','error');
   return
end
my_image = imread('./tmp/filter.jpg');
e = imfilter(my_image,fspecial('prewitt'));
imwrite(e,'./tmp/effects.jpg')
imwrite(e,'./tmp/focus.jpg');
imshow(e);


% --- Executes on button press in Laplacian.
function Laplacian_Callback(hObject, eventdata, handles)
global Filename Pathname Data;
if(strcmp(Filename,'')==1)
   h = msgbox('No image Selected','Error','error');
   return
end
my_image = imread('./tmp/filter.jpg');
e = imfilter(my_image,fspecial('laplacian'));
imwrite(e,'./tmp/effects.jpg')
imwrite(e,'./tmp/focus.jpg');
imshow(e);


% --- Executes on button press in Disk.
function Disk_Callback(hObject, eventdata, handles)
global Filename Pathname Data;
if(strcmp(Filename,'')==1)
   h = msgbox('No image Selected','Error','error');
   return
end
my_image = imread('./tmp/filter.jpg');
e = imfilter(my_image,fspecial('disk'));
imwrite(e,'./tmp/effects.jpg')
imwrite(e,'./tmp/focus.jpg');
imshow(e);


% --- Executes on button press in Compression.
function Compression_Callback(hObject, eventdata, handles)
global Flag Filename;
if(strcmp(Filename,'')==1)
   h = msgbox('No image Selected','Error','error');
   return
end
if (Flag == 1)
    Flag = 0;
elseif(Flag ==0)
    Flag =1;
else
    Flag=0;
end
       


% --- Executes on button press in imgname.
function imgname_Callback(hObject, eventdata, handles)
global Filename Pathname Data Flag;
[Filename, Pathnames] = uigetfile({'*.jpg';'*.tif';'*.png';'*.*'},'File Selector');
set(handles.text2,'String',Filename)
Data = imread(Filename);
Flag = 0;
imwrite(Data,'./tmp/filter.jpg');
imwrite(Data,'./tmp/focus.jpg');
imwrite(Data,'./tmp/effects.jpg');


% --- Executes when selected object is changed in uipanel11.
function uipanel11_SelectionChangeFcn(hObject, eventdata, handles)
global Filename Pathname Data;
if(strcmp(Filename,'')==1)
   h = msgbox('No image Selected','Error','error');
   return
end
switch get(eventdata.NewValue,'Tag')
    case 'None'
       Data = imread(Filename);
       imshow(Data);
       imwrite(Data,'./tmp/filter.jpg');
       imwrite(Data,'./tmp/focus.jpg');
    imwrite(Data,'./tmp/effects.jpg');
    
    case 'Sephia'
       Data = imread(Filename);
       [r,c,k] = size(Data)
       if(k==1)
           [X, map] = gray2ind(Data, 20480);
           Data = ind2rgb(X,map);
       end
       Data = sepia(Data);
       imshow(Data)
       imwrite(Data,'./tmp/filter.jpg');
       imwrite(Data,'./tmp/focus.jpg');
       imwrite(Data,'./tmp/effects.jpg');
       
    case 'Black'
       Data = imread(Filename);
       [r,c,k] = size(Data)
       if(k==1)
           [X, map] = gray2ind(Data, 20480);
           Data = ind2rgb(X,map);
       end
       Data = pink(Data);
       imshow(Data)
       imwrite(Data,'./tmp/filter.jpg');
       imwrite(Data,'./tmp/focus.jpg');
       imwrite(Data,'./tmp/effects.jpg');
       
    case 'Gray'
        Data = imread(Filename);
        [r,c,k] = size(Data);
        if(k~=1)
            Data = filegray(Data);
        end;        
        imshow(Data)
        imwrite(Data,'./tmp/filter.jpg');
        imwrite(Data,'./tmp/focus.jpg');
        imwrite(Data,'./tmp/effects.jpg');
    case 'Filter4'
        %imshow(imfilter(my_image,fspecial('prewitt')));
        
    case 'Filter5'
        %imshow(imfilter(my_image,fspecial('prewitt')));
end


% --- Executes on button press in Reset.
function Reset_Callback(hObject, eventdata, handles)
% hObject    handle to Reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Filename Pathname Data;
Data = imread(Filename);
delete('./tmp/filter.jpg', './tmp/focus.jpg', './tmp/effects');
imwrite(Data,'./tmp/filter.jpg');
imshow(Data)
set(handles.text2,'String',Filename)

% --- Executes on button press in Save.
function Save_Callback(hObject, eventdata, handles)
global Flag Filename Pathname;
Data = imread('./tmp/focus.jpg');
if (Flag == 1)
    Data = compress(Data);
end
delete('./tmp/filter.jpg', './tmp/focus.jpg', './tmp/effects.jpg');
imwrite(Data,'saved2.jpg');
imshow('default.jpg');
Filename = '';
Pathname = '';
set(handles.text2,'String',Filename)

% --- Executes on button press in EdgeDetect.
function EdgeDetect_Callback(hObject, eventdata, handles)
% hObject    handle to EdgeDetect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Filename ;
if(strcmp(Filename,'')==1)
   h = msgbox('No image Selected','Error','error');
   return
end
sEdge = [-1,0,1;-2,0,2;-1,0,1];
C = imread(Filename);
F = im2bw(C, .65);
E = conv2(double(F), sEdge);
F = im2bw(E, .9);
imshow(F, []);
imwrite(F,'./tmp/edge.jpg')




% --- Executes on button press in NoEffect.
function NoEffect_Callback(hObject, eventdata, handles)
% hObject    handle to NoEffect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Filename;
if(strcmp(Filename,'')==1)
   h = msgbox('No image Selected','Error','error');
   return
end
A = imread('./tmp/filter.jpg');
imwrite(A,'./tmp/effects.jpg');
imshow(A);




% --- Executes on button press in NoFocus.
function NoFocus_Callback(hObject, eventdata, handles)
% hObject    handle to NoFocus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Filename;
if(strcmp(Filename,'')==1)
   h = msgbox('No image Selected','Error','error');
   return
end
A = imread('./tmp/effects.jpg');
imwrite(A,'./tmp/focus.jpg');
imshow(A);


% --- Executes on button press in SaveFish.
function SaveFish_Callback(hObject, eventdata, handles)
% hObject    handle to SaveFish (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
x = imread('./tmp/fisheye.jpg')
imwrite(x,'fisheye.jpg')




% --- Executes on button press in SaveEdge.
function SaveEdge_Callback(hObject, eventdata, handles)
% hObject    handle to SaveEdge (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of SaveEdge
x = imread('./tmp/edge.jpg');
imwrite(x,'edge.jpg')
delete('./tmp/filter.jpg', './tmp/focus.jpg', './tmp/effects.jpg','./tmp/edge.jpg','./tmp/fisheye.jpg');