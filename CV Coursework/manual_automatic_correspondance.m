%% Combined Comparison of Manual and Automatic Correspondences
clc;
clear;
close all;

%% Setup Paths and Load Images
% Define image paths (adjust as necessary)
fd_path = 'Photos/Grid/FD/';
hg_path = 'Photos/Grid/HG/';

% Load and resize images for display (using color versions for visualization)
I1_color = imresize(imread([fd_path '1.jpg']), 0.15);
I2_color = imresize(imread([hg_path '1.jpg']), 0.15);

% Also prepare grayscale images for automatic feature detection
I1_gray = rgb2gray(I1_color);
I2_gray = rgb2gray(I2_color);

%% PART 1: Manual Keypoint Correspondence
nums = 10;  % Number of manually selected points

% Select points on Image 1
figure;
imshow(I1_color);
title('Manual Selection: Image 1');
hold on;
manualPoints1 = zeros(nums, 2);
for i = 1:nums
    [x, y] = ginput(1);
    manualPoints1(i, :) = [x, y];
    plot(x, y, 'rx', 'LineWidth', 2);
    text(x, y, num2str(i), 'Color', 'red', 'FontSize', 14);
end

% Select corresponding points on Image 2
figure;
imshow(I2_color);
title('Manual Selection: Image 2');
hold on;
manualPoints2 = zeros(nums, 2);
for i = 1:nums
    [x, y] = ginput(1);
    manualPoints2(i, :) = [x, y];
    plot(x, y, 'go', 'LineWidth', 2);
    text(x, y, num2str(i), 'Color', 'green', 'FontSize', 14);
end

% Display the manually selected matches
figure;
showMatchedFeatures(I1_color, I2_color, manualPoints1, manualPoints2, 'montage');
title('Manual Matched Features');

% Estimate projective transformation using manual points
% Using the two-output syntax returns inlier indices when inputs are matrices.
[tform_manual, inlierIdx_manual] = estimateGeometricTransform2D(manualPoints1, manualPoints2, 'projective');
inlierPoints1_manual = manualPoints1(inlierIdx_manual, :);
inlierPoints2_manual = manualPoints2(inlierIdx_manual, :);

% Display inlier matches for manual method
figure;
showMatchedFeatures(I1_color, I2_color, inlierPoints1_manual, inlierPoints2_manual, 'montage');
title('Inlier Matches (Manual)');

% Project points from Image 1 using the estimated transform
numManual = size(manualPoints1, 1);
manualPoints1_hom = [manualPoints1, ones(numManual, 1)];
projected_manual = (tform_manual.T * manualPoints1_hom.').';
projected_manual = projected_manual(:, 1:2) ./ projected_manual(:, 3);

% Compute Mean Squared Error (MSE) for manual correspondences
mse_manual = immse(manualPoints2, projected_manual);
fprintf('Manual Method - Mean Squared Error (MSE): %.4f\n', mse_manual);

%% PART 2: Automatic Keypoint Detection and Matching
% Detect KAZE features in both images
points1_auto = detectSURFFeatures(I1_gray);
points2_auto = detectSURFFeatures(I2_gray);

% Extract descriptors
[features1_auto, validPoints1_auto] = extractFeatures(I1_gray, points1_auto);
[features2_auto, validPoints2_auto] = extractFeatures(I2_gray, points2_auto);

% Match features between images
indexPairs = matchFeatures(features1_auto, features2_auto);

% Retrieve the matched points locations from the point objects
matchedPoints1_auto = validPoints1_auto(indexPairs(:, 1));
matchedPoints2_auto = validPoints2_auto(indexPairs(:, 2));

% Display automatic matches
figure;
showMatchedFeatures(I1_color, I2_color, matchedPoints1_auto.Location, matchedPoints2_auto.Location, ...
    'montage', 'PlotOptions', {'r.','g.','w:'});
title('Automatic Matched Features');

% Estimate projective transformation using automatic matches
% Use the two-output syntax to get the inlier indices.
[tform_auto, inlierIdx_auto] = estimateGeometricTransform2D(matchedPoints1_auto.Location, matchedPoints2_auto.Location, 'projective');
inlierPoints1_auto = matchedPoints1_auto.Location(inlierIdx_auto, :);
inlierPoints2_auto = matchedPoints2_auto.Location(inlierIdx_auto, :);

% Display inlier matches for automatic method
figure;
showMatchedFeatures(I1_color, I2_color, inlierPoints1_auto, inlierPoints2_auto, 'montage');
title('Inlier Matches (Automatic)');

% Project points from Image 1 using the automatic transformation
numAuto = size(matchedPoints1_auto.Location, 1);
points1_auto_hom = [matchedPoints1_auto.Location, ones(numAuto, 1)];
projected_auto = (tform_auto.T * points1_auto_hom.').';
projected_auto = projected_auto(:, 1:2) ./ projected_auto(:, 3);

% Compute Mean Squared Error (MSE) for automatic correspondences
mse_auto = immse(matchedPoints2_auto.Location, projected_auto);
fprintf('Automatic Method - Mean Squared Error (MSE): %.4f\n', mse_auto);

%% PART 3: Comparison of Methods
fprintf('\nComparison of Correspondence Methods:\n');
fprintf('Manual MSE: %.4f\n', mse_manual);
fprintf('Automatic MSE: %.4f\n', mse_auto);
