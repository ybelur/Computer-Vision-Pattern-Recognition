% Modified version of camera_param.m
% Camera calibration script
clc;
clear;
close all;
% Define image set
imagePaths = { 'Photos/Grid/HG/1.jpg', 'Photos/Grid/HG/2.jpg', 'Photos/Grid/HG/3.jpg', ...
               'Photos/Grid/HG/4.jpg', 'Photos/Grid/HG/5.jpg', 'Photos/Grid/HG/6.jpg' };

% Detect checkerboard pattern
[cornerPoints, boardDims, validImages] = detectCheckerboardPoints(imagePaths);
imagePaths = imagePaths(validImages);

% Read first image to obtain dimensions
sampleImage = imread(imagePaths{1});
[imgHeight, imgWidth, ~] = size(sampleImage);

% Define real-world checkerboard dimensions
squareDim = 41.5;  % in mm
realWorldPoints = generateCheckerboardPoints(boardDims, squareDim);

% Perform camera calibration
[camParams, validImages, calibErrors] = estimateCameraParameters(cornerPoints, realWorldPoints, ...
    'EstimateSkew', true, 'EstimateTangentialDistortion', true, ...
    'NumRadialDistortionCoefficients', 2, 'WorldUnits', 'mm', ...
    'ImageSize', [imgHeight, imgWidth]);

% Visualize reprojection errors
figure; showReprojectionErrors(camParams);

% Display extrinsic parameters
figure; showExtrinsics(camParams, 'patternCentric');

% Show calibration errors
displayErrors(calibErrors, camParams);

% Apply distortion correction
correctedImage = undistortImage(sampleImage, camParams);

% Show results
figure;
subplot(1,2,1);
imshow(sampleImage);
title('Original');

subplot(1,2,2);
imshow(correctedImage);
title('Corrected');
