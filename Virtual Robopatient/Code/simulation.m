clear all; close all; clc;
%%
%Select the directory and make a list of wave files.
files = dir('C:\Users\BIRL\Desktop\Robopatient code\selected pain\');

[s_1,Fs_1]=audioread('painsoundcrunch22.wav');
[s_2,Fs_2]=audioread('painsoundcrunch9.wav');
[s_3,Fs_3]=audioread('painsoundcrunch23.wav');
[s_4,Fs_4]=audioread('painsoundcrunch32.wav');
[s_5,Fs_5]=audioread('painsoundcrunch6.wav');


%% Loading all 2D face images

% black male images
for n = 1: 100
    IM_BM_1{n} = imread(['C:\Users\BIRL\Desktop\Robopatient code\wm_1\' num2str(n) '.png']);
end


targetSize = [500 360];
alpha = 2;
ang = -90;

for g = 1: 100
r_img = centerCropWindow2d(size(IM_BM_1{g}),targetSize);
j_img = imcrop(IM_BM_1{g},r_img);
RI_BM1{g} = imresize(j_img, alpha);
end

%% simultion for both robopatient and robodoctor communication
tumour_location_x = [];
tumour_location_y = [];
userclick_x = []; 
userclick_y = []; 
time_between_click = []; 
for k = 1:10
% 2D gussian distribution map over 400X400 mm surface

 %global key_is_pressed 
 % key_is_pressed = 0; 
  
  
x=linspace(0,400,400);
y=x';  

x_var=300*rand(1);
y_var=300*rand(1);
sigma = 0.0005;
[X,Y]=meshgrid(x,y);
z=exp(-(sigma*(X-x_var).^2+sigma*(Y-y_var).^2)/2);

tumour_location_x = [tumour_location_x x_var];
tumour_location_y = [tumour_location_y y_var]; 



% dis2centroid = 4*rand(100,1);
% total_force = 13/50;
% pain_level = dis2centroid*total_force;

% pain level change is only a function of palpation location (x,y)
% pain_level = y_pain(round(x(h,1))+1);



s = 10;
 %while ~key_is_pressed
for i = 1: 21 %number of times user can click to find the tumour
 
 
    tic; %start time 
 [x, y] = ginput(1);
 userclick_x = [userclick_x x]; %saving the position of click   
 userclick_y = [userclick_y y];  %save the position of click
    toc; %stop time
    time_between_click = [time_between_click toc]; %save time 
    
    
%  dis2centroid = sqrt((x-200)^2 + (y-200)^2);
%  pain_level = 100 - dis2centroid*total_force;

x_val = round(x);
y_val = round(y);

if x_val <= 0
    x_val = 1; 
end 

if y_val <= 0 
    y_val = 1;
end 

f = round(100*(z(x_val, y_val)));

 if f >=99
        f=99;
 end
 if f<=1
        f=1;
 end
 
 
 
 
if f > 50 && f <= 65
    sound (s_1, Fs_1);
end 

if f > 65 && f <= 80
    sound (s_2, Fs_2);
end 

if f > 80 && f <= 90
    sound (s_3, Fs_3);
end 

if f > 90 && f <= 95
    sound (s_4, Fs_4);
end 

if f > 95
    sound (s_5, Fs_5);
end 

 
 var_red = f/100;
 var_green = 1 - var_red;
 
 subplot(1,2,1)
 scatter(x, y,20,'filled','MarkerFaceAlpha',.2);
 title('Abdomen of the Robopatient')
 xlim([0 400])
 ylim([0 400])
 pbaspect([1 1 1])
 grid on
%  subplot(2,2,2)
%  imagesc(z);
%  xlim([0 400]);
%  ylim([0 400]);
%  pbaspect([1 1 1])
%  camroll(90)
%  title('Stiffness distribution of the phantom under diagonsis')
 subplot(1,2,2)
 cla;
 imshow(RI_BM1{f})
 title('Robopatient Face (MorphFace)')
%  
% subplot(2,2,4)
% scatter(x, y,100,'filled','MarkerFaceColor',[var_red var_green 0]);
% xlim([0 400])
%  ylim([0 400])
%   pbaspect([1 1 1])
%  title('Robodoctor sensor readings')
 drawnow
 pause(0.1)
end
close all 
   %end
   close all 
end


 
5%%  simulation for robopatient

x_pool = [0 150 300];
y_pool = [0 150 300];

x_index = randperm(3);
y_index = randperm(3);

% 2D gussian distribution map over 400X400 mm surface
x=linspace(0,400,400);
y=x';  
% x_var=300*rand(1);
% y_var=300*rand(1);

k=0;
for m=1:3
    for n=1:3
       
        k = k+1;

x_var=x_pool(x_index(m));
y_var=y_pool(y_index(n));

x_mu_arry(:,k) = x_var;
y_mu_arry(:,k) = y_var;

sigma = 0.0005;
[X,Y]=meshgrid(x,y);
z=exp(-(sigma*(X-x_var).^2+sigma*(Y-y_var).^2)/2);



for i = 1: 10
 [h, g] = ginput(1); 
%  dis2centroid = sqrt((x-200)^2 + (y-200)^2);
%  pain_level = 100 - dis2centroid*total_force;

x_val = round(h);
y_val = round(g);

f = round(100*(z(x_val, y_val)));

 if f >=99
        f=99;
 end
 if f<=1
        f=1;
 end
 
 x_arr(i,k) = x_val;
 y_arr(i,k) = y_val;
 f_arr(i,k) = f;
 
 subplot(1,2,1)
 scatter(h, g,20,'filled','MarkerFaceAlpha',.2);
 title('Abdomen of the Robopatient')
 xlim([0 400])
 ylim([0 400])
 pbaspect([1 1 1])
 subplot(1,2,2)
 imshow(RI_BM1{f})
 title('Robopatient Face (MorphFace)')
 drawnow
 pause(0.1)
end
    end
end

%%

%%
userclick_xCopy = 1:210; 
B = reshape(userclick_xCopy, [21, 10])



 

%% ploting the data
 k=0;
for m=1:3
    for n=1:3
        k = k + 1;
        subplot(3,3,k);
 scatter(x_arr(:,k),y_arr(:,k),'x')
 hold on;
 scatter(x_mu_arry(k),y_mu_arry(k));
 title(['attempt', num2str(k)]);
 xlim([0 400])
 ylim([0 400])
    end
end