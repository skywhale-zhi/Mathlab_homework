function varargout = untitled(varargin)
% UNTITLED MATLAB code for untitled.fig
%      UNTITLED, by itself, creates a new UNTITLED or raises the existing
%      singleton*.
%
%      H = UNTITLED returns the handle to a new UNTITLED or the handle to
%      the existing singleton*.
%
%      UNTITLED('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in UNTITLED.M with the given input arguments.
%
%      UNTITLED('Property','Value',...) creates a new UNTITLED or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before untitled_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to untitled_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help untitled

% Last Modified by GUIDE v2.5 27-Apr-2022 19:43:19

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @untitled_OpeningFcn, ...
                   'gui_OutputFcn',  @untitled_OutputFcn, ...
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


% --- Executes just before untitled is made visible.
function untitled_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to untitled (see VARARGIN)
setappdata(handles.figure1,'img',0);
setappdata(handles.figure1,'imgOK',0);


% Choose default command line output for untitled
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes untitled wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = untitled_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%按下晶格化按钮
img1=getappdata(handles.figure1,'img');
%--------------------------------------------------------------
A=img1;
[L,N]=superpixels(A,200);
imgOK = zeros(size(A),'like',A);
idx = label2idx(L);
numRows = size(A,1);
numCols = size(A,2);
for labelVal = 1:N
    redIdx = idx{labelVal};
    greenIdx = idx{labelVal}+numRows*numCols;
    blueIdx = idx{labelVal}+2*numRows*numCols;
    imgOK(redIdx) = mean(A(redIdx));
    imgOK(greenIdx) = mean(A(greenIdx));
    imgOK(blueIdx) = mean(A(blueIdx));
end    
%--------------------------------------------------------------
axes(handles.axes2);
imshow(imgOK);
setappdata(handles.figure1,'imgOK',imgOK);


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%聚焦按钮

img1=getappdata(handles.figure1,'img');
%--------------------------------------------------------------

src=img1;
srcgray=rgb2gray(src);%首先进行灰度变换
[height,width] = size(srcgray);%获得图像的高度和宽度
centery=width/2;
centerx=height/2;


maxv=centerx*centerx+centery*centery;
msize=0.1;%改变这个值，可以改变效果
minv=(maxv*(1-msize));
diff=maxv-minv;
%ratio=width>height? height/width : width/height;
if width>height
    ratio=(height/width);
else
    ratio=(width/height);
end
height=height-1;
width=width-1;
for x=1:height
    for y=1:width
        r=src(x,y,1);
        g=src(x,y,2);
        b=src(x,y,3);        
        dy=centery-y;      
        dx=centerx-x;     
        dstsq=(dx*dx+dy*dy);        
        v=((dstsq/diff)*75);
        r=r-v;
        g=g-v;
        b=b-v;        
      if r>255
          r=255;
      elseif r<0
          r=0;
      end      
      if g>255
        g=255;
      elseif g<0
         g=0;
      end
      
      if b>255
          b=255;
      elseif b<0
          b=0;
      end
      imgOK(x,y,1)=uint8(r);
      imgOK(x,y,2)=uint8(g);
      imgOK(x,y,3)=uint8(b);      
    end    
end
%--------------------------------------------------------------
axes(handles.axes2);
imshow(imgOK);
setappdata(handles.figure1,'imgOK',imgOK);



% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%浮雕按钮
img1=getappdata(handles.figure1,'img');
%----------------------------------------------------------------------
I=rgb2gray(img1);
I=double(I);  %这样I相减才能得到负数
[m,n]=size(I);
imgOK=zeros(m,n);
for x=2:m-1
    for y=2:n-1
        imgOK(x,y)=I(x-1,y-1)+I(x,y-1)+I(x-1,y)-I(x+1,y+1)-I(x,y+1)-I(x+1,y);
    end
end
imgOK=imgOK+128;
imgOK=uint8(imgOK);
%----------------------------------------------------------------------
axes(handles.axes2);
imshow(imgOK);
setappdata(handles.figure1,'imgOK',imgOK);



% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%怀旧按钮
img1=getappdata(handles.figure1,'img');
%----------------------------------------------------------------------
[h w k]=size(img1);
imshow(img1);

R=double(img1(:,:,1));
G=double(img1(:,:,2));
B=double(img1(:,:,3));

rR=R*0.393+G*0.769+B*0.198;
rG=R*0.349+G*0.686+B*0.168;
rB=R*0.272+G*0.534+B*0.131;

randR=rand()*0.5+0.5;
randG=rand()*0.5+0.5;
randB=rand()*0.5+0.5;

imgOK=zeros(h,w,k);
imgOK(:,:,1)=randR*rR+(1-randR)*R;
imgOK(:,:,2)=randG*rG+(1-randG)*G;
imgOK(:,:,3)=randB*rB+(1-randB)*B;
imgOK=uint8(imgOK);
%----------------------------------------------------------------------
axes(handles.axes2);
imshow(imgOK);
setappdata(handles.figure1,'imgOK',imgOK);



% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%打开图片按钮
[filename,pathname]=uigetfile({'*jpg;*.bmp;*.jpeg'},'show image');%加载路径选择
fpath=[pathname,filename];%总路径
img=imread(fpath);%读图片
axes(handles.axes1);%选择要显示的句柄
imshow(img);%显示图片
setappdata(handles.figure1,'img',img);




% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%保存图片按钮
img=getappdata(handles.figure1,'imgOK');
imwrite(img,[datestr(now,30),'.jpg']);


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%关闭程序按钮
close(handles.figure1);


% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes1
 

% --- Executes during object creation, after setting all properties.
function axes2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes2
