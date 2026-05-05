% Original Image
Img = imread('Image.png');
% RGB Adjustment
RGBadjust = imadjust(A, [118/255 82/255 0; 254/255 247/255 204/255],[]);


I = rgb2hsv(RGBadjust);
% Define thresholds for 'Hue'.
channel1Min = 0.965;
channel1Max = 0.188;
% Define thresholds for 'Saturation'
channel2Min = 0.000;
channel2Max = 1.000;
% Define thresholds for 'Value'
channel3Min = 0.000;
channel3Max = 1.000;
% Create mask based on chosen histogram thresholds
BW = ( (I(:,:,1) >= channel1Min) | (I(:,:,1) <= channel1Max) ) & ...
    (I(:,:,2) >= channel2Min ) & (I(:,:,2) <= channel2Max) & ...
    (I(:,:,3) >= channel3Min ) & (I(:,:,3) <= channel3Max);
% Initialize output masked image based on input image.
maskedRGBImage = RGBadjust;
% Set background pixels where BW is false to zero.
maskedRGBImage(repmat(~BW,[1 1 3])) = 0;

% Grayscaling the Image
Gray = rgb2gray(maskedRGBImage);
% Medium Filter
filteredImg = medfilt2(Gray);
threshold = graythresh(filteredImg);
binaryImg = im2bw(filteredImg,threshold);
% Eliminating Objects under 200px
binaryImg = bwareaopen(binaryImg, 200);
% Perform morphological operations to enhance the binary image
se = strel('disk', 10);
binaryImg = imclose(binaryImg, se);
binaryImg = imfill(binaryImg, 'holes');
binaryImg = imopen(binaryImg, se);


% Perform blob analysis to get the properties of the mangoes
blobAnalysis = regionprops(binaryImg, 'Area', 'BoundingBox', 'Centroid');
numMangoes = length(blobAnalysis);

% Draw bounding boxes around the mangoes
figure;
imshow(A);
hold on;
for i = 1:numMangoes
    rectangle('Position', blobAnalysis(i).BoundingBox, 'EdgeColor', 'r', 'LineWidth', 2);
end
title(sprintf('%d mango(es) detected',numMangoes));