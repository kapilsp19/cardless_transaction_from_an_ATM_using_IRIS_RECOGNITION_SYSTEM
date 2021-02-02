 
%main file that run the main program 
image_name=0;

imaqreset;


cam1 =  videoinput('winvideo', 2, 'RGB24_640x480');
src = getselectedsource(cam1);
%serial1=serial('COM4');

%fopen(serial1);
cam1.FramesPerTrigger = 1;

cam1.ReturnedColorspace = 'rgb';

triggerconfig(cam1, 'manual');
cam1.TriggerRepeat = Inf;

%start(cam1);

start(cam1)
eye=getsnapshot(cam1);

%eye=imread(a);


%Image enhancement and adjustment 
eye=rgb2gray(eye);
eye=imresize(eye,[183,275]);

eye=imadjust(eye);





%applying the alogrtym 
[ci,cp,out] = daugman(eye,10,100);

figure
imshow(out);

% normalizing the image


[ring,parr]=rubberSheetNormalisation(eye,ci(2),ci(1),ci(3),cp(2),cp(1),cp(3),'normal.bmp',200,500);

figure
imshow(parr);

