%% Task 3: Camera Calibration
% This script performs camera calibration using a set of images of a calibration grid.
% It finds and reports the camera parameters and illustrates the effect of lens distortions.
% Requirements: Computer Vision Toolbox

% Clear workspace and close figures
clear; close all; clc;

%% 1. Specify Calibration Images
% List your calibration image file names here.
% Ensure these images show a calibration grid (e.g., checkerboard) taken from different views.
imageFileNames = { 'Photos/No_Object/FD/1.jpg', 'Photos/No_Object/FD/2.jpg', 'Photos/No_Object/FD/3.jpg', 'Photos/No_Object/FD/4.jpg', 'Photos/No_Object/FD/5.jpg', 'Photos/No_Object/FD/6.jpg' };

%% 2. Detect Checkerboard Points
% detectCheckerboardPoints automatically finds the corners in the grid pattern.
% It returns the image coordinates of the detected corners and the board size.
[imagePoints, boardSize, imagesUsed] = detectCheckerboardPoints(imageFileNames);
fprintf('Detected a %d x %d checkerboard pattern.\n', boardSize(1), boardSize(2));

% Optionally, display the detected points on one of the images.
I = imread(imageFileNames{find(imagesUsed,1)});
figure; imshow(I); hold on;
plot(imagePoints(:,1), imagePoints(:,2), 'ro');
title('Detected Checkerboard Points');

%% 3. Define World Coordinates for the Checkerboard Corners
% Specify the size of one square in world units (e.g., millimeters).
squareSize = 25;  % Change to your actual square size
worldPoints = generateCheckerboardPoints(boardSize, squareSize);

%% 4. Estimate Camera Parameters
% Read one image to get the image size.
I = imread(imageFileNames{find(imagesUsed,1)});
imageSize = [size(I,1), size(I,2)];

% Estimate the intrinsic and extrinsic camera parameters.
cameraParams = estimateCameraParameters(imagePoints, worldPoints, ...
    'ImageSize', imageSize);

% Display reprojection errors.
figure; 
showReprojectionErrors(cameraParams);
title('Reprojection Errors');

% Display camera extrinsics.
figure;
showExtrinsics(cameraParams, 'CameraCentric');
title('Camera Extrinsics');

%% 5. Report Camera Parameters
% The cameraParams structure contains the intrinsic matrix and distortion coefficients.
disp('Estimated Camera Intrinsics:');
disp(cameraParams.Intrinsics);

% Optionally, print out a summary.
fprintf('\nFocal Length (in pixels): [%.2f, %.2f]\n', ...
    cameraParams.Intrinsics.FocalLength);
fprintf('Principal Point (in pixels): [%.2f, %.2f]\n', ...
    cameraParams.Intrinsics.PrincipalPoint);
fprintf('Radial Distortion Coefficients: [%.4f, %.4f]\n', ...
    cameraParams.Intrinsics.RadialDistortion);
fprintf('Tangential Distortion Coefficients: [%.4f, %.4f]\n\n', ...
    cameraParams.Intrinsics.TangentialDistortion);

%% 6. Illustrate Lens Distortion Effects
% Show an example of an original image and its undistorted version.

% Read one of the calibration images.
originalImage = imread(imageFileNames{find(imagesUsed,1)});

% Undistort the image using the estimated camera parameters.
undistortedImage = undistortImage(originalImage, cameraParams);

% Display both images for comparison.
figure;
subplot(1,2,1);
imshow(originalImage);
title('Original Image');

subplot(1,2,2);
imshow(undistortedImage);
title('Undistorted Image');

% Optionally, overlay grid lines or feature points if desired.

%% End of Script
disp('Camera calibration completed.');
