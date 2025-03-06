clc; clear; close all;

% Load images (Replace 'img1.jpg' and 'img2.jpg' with your actual filenames)
img1 = imread('Photos/Grid/HG/2.jpg'); 
img2 = imread('Photos/Grid/FD/2.jpg');

%% ======== TASK 4.1: Homography Matrix Estimation ===========
% Convert images to grayscale
gray1 = rgb2gray(img1);
gray2 = rgb2gray(img2);

% Detect feature points
points1 = detectSURFFeatures(gray1);
points2 = detectSURFFeatures(gray2);

% Extract descriptors
[features1, validPoints1] = extractFeatures(gray1, points1);
[features2, validPoints2] = extractFeatures(gray2, points2);

% Match features
indexPairs = matchFeatures(features1, features2, 'MaxRatio', 0.7, 'Unique', true);
matchedPoints1 = validPoints1(indexPairs(:,1), :);
matchedPoints2 = validPoints2(indexPairs(:,2), :);

% Compute Homography using RANSAC
[H, inliers] = estimateGeometricTransform2D(matchedPoints1, matchedPoints2, 'projective', 'MaxNumTrials', 2000);

% Visualize keypoint correspondences
figure; showMatchedFeatures(img1, img2, matchedPoints1, matchedPoints2, 'montage', 'PlotOptions', {'r.','g.','w:'});
title('Keypoints Matching for Homography Estimation');

% Warp one image using estimated homography
outputView = imref2d(size(gray1));
warpedImage = imwarp(img1, H, 'OutputView', outputView);
figure; imshowpair(warpedImage, img2, 'blend');
title('Warped Image Using Homography');

%% ======== TASK 4.2: Fundamental Matrix Estimation ===========
% Detect feature points again
points1 = detectSURFFeatures(gray1);
points2 = detectSURFFeatures(gray2);

% Extract features
[features1, validPoints1] = extractFeatures(gray1, points1);
[features2, validPoints2] = extractFeatures(gray2, points2);

% Match features
indexPairs = matchFeatures(features1, features2, 'MaxRatio', 0.7, 'Unique', true);
matchedPoints1 = validPoints1(indexPairs(:,1), :);
matchedPoints2 = validPoints2(indexPairs(:,2), :);

% Compute Fundamental Matrix using RANSAC
[F, inliers] = estimateFundamentalMatrix(matchedPoints1, matchedPoints2, 'Method', 'RANSAC');

% Display epipolar lines
figure;
subplot(1,2,1);
imshow(img1); hold on;
title('Epipolar Lines in Image 1');
epiLines1 = epipolarLine(F', matchedPoints2.Location);
points = lineToBorderPoints(epiLines1, size(img1));
line(points(:, [1,3])', points(:, [2,4])', 'Color', 'r');

subplot(1,2,2);
imshow(img2); hold on;
title('Epipolar Lines in Image 2');
epiLines2 = epipolarLine(F, matchedPoints1.Location);
points = lineToBorderPoints(epiLines2, size(img2));
line(points(:, [1,3])', points(:, [2,4])', 'Color', 'b');

%% ======== TASK 4.3: Outlier Tolerance Analysis ===========
% Compute number of inliers
numInliers = sum(inliers);
numOutliers = length(inliers) - numInliers;

fprintf('Number of inliers: %d\n', numInliers);
fprintf('Number of outliers: %d\n', numOutliers);
fprintf('Outlier Tolerance Ratio: %.2f%%\n', (numOutliers / length(inliers)) * 100);
