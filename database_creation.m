
clc;
clear all;
close all;
warning off;
vid = webcam('USB 2.0 WebCamera'); 

final_feature1=[];
for i=1:6
%% %% TAKE THE INPUT IMAGE FROM THE CAMERA
preview(vid);
%% Image Acquistition
pause(10);
im1 = snapshot(vid);
figure,imshow(im1); title('Input Image')
%% %% PRE PROCESSING
%%Gray Conversion
[m n o] = size(im1);
if o == 3
    gray = rgb2gray(im1);
else
    gray = I;
end
% figure,imshow(gray);
% title('Grayscale image');
%% EHD
F1 = [1 2 1;0 0 0;-1 -2 -1];
I1 = imfilter(gray,F1);
% figure,imshow(I1);
% title('EHD1');

F2 = [-1 0 1;-2 0 2;-1 0 1];
I2 = imfilter(gray,F2);
% figure,imshow(I2);
% title('EHD2');

F3 = [2 2 -1;2 -1 -1;-1 -1 -1];
I3 = imfilter(gray,F3);
% figure,imshow(I3);
% title('EHD3');

F4 = [-1 -1 2;-1 2 2;-1 -1 -1];
I4 = imfilter(gray,F4);
% figure,imshow(I4);
% title('EHD4');

F5 = [-1 0 1;0 0 0;1 0 -1];
I5 = imfilter(gray,F5);
% figure,imshow(I5);
% title('EHD5');

for i = 1:m
    for j = 1:n
        L_index(i,j) = max([I1(i,j) I2(i,j) I3(i,j) I4(i,j) I5(i,j)]);
    end
end
% figure,imshow(L_index);
% title('Edge Histogram Descriptor');

Ie = edge(gray,'canny');
% figure,imshow(Ie);
% title('Canny Edge Output');

Lf = Ie.*double(L_index);
% figure,imshow(Lf);
% title('Final EHD');

%% Feature Extraction
% Edge Histogram Feature
edge_feature = hist(Lf(:),5);
% Color Feature
color_feature = color_luv(im1);
% Gray Level Co-occurance Matrix
out = graycomatrix(gray);
GLCM_feature = mean(out);

combined_feature = [edge_feature color_feature' GLCM_feature];

final_feature1 = [final_feature1;combined_feature];
end
 final_feature1(:,end+1) = [1;1;1;2;2;2];
 save('final_feature1','final_feature1');