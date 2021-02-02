function varargout = gui_iris_main(varargin)
% GUI_IRIS_MAIN MATLAB code for gui_iris_main.fig
%      GUI_IRIS_MAIN, by itself, creates a new GUI_IRIS_MAIN or raises the existing
%      singleton*.
%
%      H = GUI_IRIS_MAIN returns the handle to a new GUI_IRIS_MAIN or the handle to
%      the existing singleton*.
%
%      GUI_IRIS_MAIN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_IRIS_MAIN.M with the given input arguments.
%
%      GUI_IRIS_MAIN('Property','Value',...) creates a new GUI_IRIS_MAIN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_iris_main_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_iris_main_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_iris_main

% Last Modified by GUIDE v2.5 15-Mar-2018 00:25:55

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_iris_main_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_iris_main_OutputFcn, ...
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


% --- Executes just before gui_iris_main is made visible.
function gui_iris_main_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui_iris_main (see VARARGIN)

% Choose default command line output for gui_iris_main
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui_iris_main wait for user response (see UIRESUME)
% uiwait(handles.figure1);
global serial1;
delete(instrfind);
%serial1=serial('COM8');
%fopen(serial1);




  
  

    






% --- Outputs from this function are returned to the command line.
function varargout = gui_iris_main_OutputFcn(hObject, eventdata, handles) 
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
global cam1 serial1 temp name12
match=0;
msgbox('Please put your Eyes in front of camera');
stop(cam1);
start(cam1);
answer12 = inputdlg('Please press Ok button','press Ok');
trigger(cam1);
a=getdata(cam1);

eye=rgb2gray(a);
eye=imresize(eye,[183,275]);

eye=imadjust(eye);

%applying the alogrtym 
[ci,cp,out] = daugman(eye,10,100);

% figure
% imshow(out);

axes(handles.axes3)
imshow(out);


% normalizing the image


[ring,parr]=rubberSheetNormalisation(eye,ci(2),ci(1),ci(3),cp(2),cp(1),cp(3),'normal.bmp',200,500);

% % figure
% % imshow(parr);

parr=adapthisteq(parr);
axes(handles.axes2)
imshow(parr);

[temp th tv]=gen_templateVVV(parr);


% subplot(1,2,2);imshow(temp);

file_right=dir('C:\Users\kapil\Desktop\Gui_iris_main\Gui_iris_main\TrainDatabase1\right');
file_left=dir('C:\Users\kapil\Desktop\Gui_iris_main\Gui_iris_main\TrainDatabase1\left');
disp(file_right)
disp(file_left)

if isempty(file_right)==0

    for i=3:size(file_right,1)
    
    name_right=file_right(i).name;
    temp2=imread(strcat('C:\Users\kapil\Desktop\Gui_iris_main\Gui_iris_main\TrainDatabase1\right\',name_right));
    disp(name_right);
    hd=hammingdist(temp, temp2);
    disp(hd);
    if(hd<=0.37)
    match=1;
        break;

    else
    
    end
    
    
    
    end
        
end

if isempty(file_left)==0 && match==0

    for i=3:size(file_left,1)
     name_left=file_left(i).name;
     disp(name_right);
    temp2=imread(strcat('C:\Users\kapil\Desktop\Gui_iris_main\Gui_iris_main\TrainDatabase1\left\',name_left));
    hd=hammingdist(temp, temp2);
    disp(hd)
    if(hd<=0.37)
        match=2;
        break;
    else
    
    end
    end
        
end

dbname='atm';
username='root';
pwd='root';
driver='com.mysql.jdbc.Driver';
dburl=['jdbc:mysql://localhost:3306/' dbname] ;
javaaddpath('C:\Program Files\MATLAB\R2013a\java\mysql-connector-java-5.1.46-bin.jar');
conn=database(dbname,username,pwd,driver,dburl);




global f_right

if match==1
name12=strsplit(name_right,'.');    
f_right=fetch(conn,['select * from main where Holder_name=' '''' name12{1} '''']);
f_bank=fetch(conn,['select Bank from main where Holder_name=' '''' name12{1} '''']);

local_r=(f_right{end}=='L' | f_right{end}=='l');

if local_r==1
    
    f_rightp=fetch(conn,['select Phone1 from main where acount=' '''' f_right{3} ''''  '&&' 'Member=''O''']);
    
    
    fprintf(serial1,'%s',f_rightp{1});
    %pause(1)
    
    while(serial1.available()<0)
    end
    
    rec=fread(serial1);
    
    if (rec=='0')
        msgbox('Access Denied');
        pause(1);
        return
    end
end
 
fileID = fopen('exptable.txt','w');
siz=size(f_bank,1);
zx=strcat(f_right{2});
fprintf(fileID,zx);
for i=1:siz
    fprintf(fileID,',');
    fprintf(fileID,f_bank{i});
end
    
    



fclose(fileID);
disp(f_right);
page2
end

if match==2
name13=strsplit(name_left,'.'); 
f_left=fetch(conn,['select * from main where Holder_name=' '''' name13{1} '''']);





local=(f_left(end)=='L' || f_left(end)=='l');

if local==1
    
    f_leftp=fetch(conn,['select Phone1 from main where acount=' '''' f_left{3} ''''  '&&' 'Member=O']);
    
%    fprintf(s,'%s',name13(1));
 %   fprintf(s,'%s',f_leftp);
    
    pause(1)
    
    while(serial1.available()<0)
    end
    
    rec=fread(serial1);
    
    if (rec=='0')
        msgbox('Acess Denied');
        pause(1);
        return
    end
end
        
fileID = fopen('exptable.txt','w');
fprintf(fileID,f_left);
fclose(fileID);
disp(f_left);
page2

end

disp(match)









  
  
 




% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global cam1 serial1 temp temp1;
mkdir('TrainDatabase1/left');
mkdir('TrainDatabase1/right');


%start(cam1);


% name=input('Enter the Name of Person in Data Base','s');
% acount=input('Enter the Acount Number','s');
% phone1=input('Enter The First Number','s');
% phone2=input('Enter The Second Number','s');
% Bank=input('Enter The Bank Name','s');
 prompt = {'Enter the Name of Person in Data Base','Enter the acount Number','Enter The First Number','Enter The Second Number','Enter The Bank Name','Type'};
title = 'Detail';
dims = [1 35];
answer = inputdlg(prompt,title,dims);


msgbox('Show your Right Eye');
pause(1);
%trigger(cam1);

answer12 = inputdlg('Plz press and Press Buton Ok','press Ok');

a=getsnapshot(cam1);

eye=rgb2gray(a);
eye=imresize(eye,[183,275]);

eye=imadjust(eye);

%applying the alogrtym 

[ci,cp,out] = daugman(eye,10,100);

% normalizing the image

axes(handles.axes3)
imshow(out);

[ring,parr]=rubberSheetNormalisation(eye,ci(2),ci(1),ci(3),cp(2),cp(1),cp(3),'normal.bmp',200,500);



parr=adapthisteq(parr);

axes(handles.axes2)
imshow(parr);



[temp th tv]=gen_templateVVV(parr);

file_name=strcat(answer{1},'.jpg');
location_right=strcat('TrainDatabase1/right/',file_name);
disp(location_right);
imwrite(temp,location_right);

%stop(cam1);
pause(1);

msgbox('Show your Left Eye');
%start(cam1);
pause(1);
%trigger(cam1);
answer12 = inputdlg('Plz press and Press Buton Ok','press Ok');
a1=getsnapshot(cam1);

eye1=rgb2gray(a1);
eye1=imresize(eye1,[183,275]);

eye1=imadjust(eye1);

%applying the alogrtym 

[ci1,cp1,out1] = daugman(eye1,10,100);

% normalizing the image


axes(handles.axes3)
imshow(out1);


[ring1,parr1]=rubberSheetNormalisation(eye1,ci1(2),ci1(1),ci1(3),cp1(2),cp1(1),cp1(3),'normal1.bmp',200,500);



parr1=adapthisteq(parr1);

axes(handles.axes2)
imshow(parr1);


[temp1 th1 tv1]=gen_templateVVV(parr1);
%subplot(1,2,2);imshow(temp);
file_name_left=strcat(answer{1},'.jpg');
location_left=strcat('TrainDatabase1/left/',file_name);
imwrite(temp1,location_left);
%stop(cam1);
dbname='atm';
username='root';
pwd='root';
driver='com.mysql.jdbc.Driver';
dburl=['jdbc:mysql://localhost:3306/' dbname] ;
javaaddpath('C:\Program Files\MATLAB\R2013a\java\mysql-connector-java-5.1.46-bin.jar');
conn=database(dbname,username,pwd,driver,dburl);

if isempty(conn.Message)
    disp(' Database is  working')
      
else
    disp('data Base is Not worrking')
     close(gui_iris_main);
end








if isempty(answer)==0
datainsert(conn,'main',{'Holder_name' 'Location_right' 'Bank' 'Phone1' 'Phone2' 'Location_left' 'acount' 'Member'},{answer{1} location_right answer{5} answer{3} answer{4} location_left answer{2} answer{6}})
end














% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global cam1 serial1

image_name=0;

imaqreset;


cam1 = videoinput('winvideo', 1, 'MJPG_1280x720');
src = getselectedsource(cam1);
%serial1=serial('COM8');

%fopen(serial1);
cam1.FramesPerTrigger = 1;

cam1.ReturnedColorspace = 'rgb';

triggerconfig(cam1, 'manual');
cam1.TriggerRepeat = Inf;

%start(cam1);

z=image(zeros(720,1280),'parent',handles.axes1);
  preview(cam1,z);

 
