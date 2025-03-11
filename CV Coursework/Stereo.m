%% Task 5: 3D Geometry - Stereo Rectification and Depth Map Calculation
% This script assumes you have a stereo pair (e.g., 'FD1.jpg' and 'FD2.jpg')
% taken from different viewpoints. The code:
%   1) Rectifies the images using an uncalibrated method.
%   2) Displays the rectified pair with horizontal epipolar lines.
%   3) Computes a disparity map.
%   4) Computes a depth map from the disparity map.
%
% Requirements: Computer Vision Toolbox

clear; close all; clc;

%% 1. Load Stereo Images
I1 = imread('Photos/Grid/FD/6.jpg');  % Left image
I2 = imread('Photos/Grid/HG/6.jpg');  % Right image

% Convert to grayscale if needed
if size(I1,3)==3, I1_gray = rgb2gray(I1); else, I1_gray = I1; end
if size(I2,3)==3, I2_gray = rgb2gray(I2); else, I2_gray = I2; end

%% 2. Detect and Match Features to Estimate the Fundamental Matrix
% Detect features in both images.
points1 = detectSURFFeatures(I1_gray);
points2 = detectSURFFeatures(I2_gray);

% Extract features.
[features1, validPoints1] = extractFeatures(I1_gray, points1);
[features2, validPoints2] = extractFeatures(I2_gray, points2);

% Match features between the two images.
indexPairs = matchFeatures(features1, features2, 'Unique', true);
matchedPoints1 = validPoints1(indexPairs(:,1));
matchedPoints2 = validPoints2(indexPairs(:,2));

% Estimate the fundamental matrix using RANSAC.
[F, inliers] = estimateFundamentalMatrix(matchedPoints1, matchedPoints2, ...
    'Method', 'RANSAC', 'NumTrials', 2000, 'DistanceThreshold', 1e-4);

% Retain only the inlier matches.
inlierPoints1 = matchedPoints1(inliers);
inlierPoints2 = matchedPoints2(inliers);

%% 3. Perform Uncalibrated Stereo Rectification
% Estimate rectification transforms for both images.
[t1, t2] = estimateUncalibratedRectification(F, ...
    inlierPoints1.Location, inlierPoints2.Location, size(I1_gray));

% Create projective transformations.
rectifyTform1 = projective2d(t1);
rectifyTform2 = projective2d(t2);

% Warp the images to obtain rectified images.
[I1_rect, ref1] = imwarp(I1_gray, rectifyTform1);
[I2_rect, ref2] = imwarp(I2_gray, rectifyTform2);

% Display the rectified images side-by-side.
figure('Name','Rectified Stereo Pair');
subplot(1,2,1);
imshow(I1_rect, ref1);
title('Rectified Image 1');
subplot(1,2,2);
imshow(I2_rect, ref2);
title('Rectified Image 2');

%% 4. Overlay Epipolar (Horizontal) Lines on the Rectified Images
% In rectified images, epipolar lines become horizontal. We overlay lines at
% regular vertical intervals.
numLines = 10;
lineSpacing1 = floor(size(I1_rect,1) / numLines);
lineSpacing2 = floor(size(I2_rect,1) / numLines);

figure('Name','Epipolar Lines on Rectified Images');
subplot(1,2,1);
imshow(I1_rect, ref1); hold on;
for k = 1:numLines
    y = k * lineSpacing1;
    line([1, size(I1_rect,2)], [y, y], 'Color', 'r', 'LineStyle', '--');
end
title('Rectified Image 1 with Epipolar Lines');
hold off;

subplot(1,2,2);
imshow(I2_rect, ref2); hold on;
for k = 1:numLines
    y = k * lineSpacing2;
    line([1, size(I2_rect,2)], [y, y], 'Color', 'r', 'LineStyle', '--');
end
title('Rectified Image 2 with Epipolar Lines');
hold off;

%% 5. Compute Disparity Map
% Define the disparity search range (adjust as needed).
disparityRange = [0 64];

% Compute the disparity map using the rectified images.
disparityMap = disparity(I1_rect, I2_rect, 'DisparityRange', disparityRange);

% Display the disparity map.
figure('Name','Disparity Map');
imshow(disparityMap, disparityRange);
title('Disparity Map');
colormap(gca, jet);
colorbar;

%% 6. Calculate and Display Depth Map
% To convert disparity to depth, use the formula:
%       depth = (focalLength * baseline) ./ disparity
% You must supply the focal length (in pixels) and baseline (in meters) from your calibration.
% For demonstration, we use example values.
focalLength = 700;  % Example focal length in pixels (adjust as per your calibration)
baseline = 0.1;     % Example baseline in meters (adjust as per your setup)

% Avoid division by zero (set depth to Inf where disparity is 0).
depthMap = (focalLength * baseline) ./ double(disparityMap);
depthMap(disparityMap == 0) = Inf;

% Display the depth map.
figure('Name','Depth Map');
imshow(depthMap, [0, 5]); % Adjust display range as needed.
title('Depth Map');
colormap(gca, jet);
colorbar;

%% End of Script
disp('Stereo rectification, disparity, and depth map computation completed.');
