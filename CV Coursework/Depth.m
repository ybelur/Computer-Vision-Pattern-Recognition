clc; clear; close all;

% Load stereo images (Modify file names accordingly)
leftImg = imread('Photos/Grid/HG/6.jpg');  
rightImg = imread('Photos/Grid/FD/6.jpg'); 

% Convert to grayscale (if necessary)
if size(leftImg, 3) == 3
    leftImgGray = rgb2gray(leftImg);
    rightImgGray = rgb2gray(rightImg);
else
    leftImgGray = leftImg;
    rightImgGray = rightImg;
end

% Detect and extract features
points1 = detectSURFFeatures(leftImgGray);
points2 = detectSURFFeatures(rightImgGray);
[features1, validPoints1] = extractFeatures(leftImgGray, points1);
[features2, validPoints2] = extractFeatures(rightImgGray, points2);

% Match features
indexPairs = matchFeatures(features1, features2, 'Unique', true);
matchedPoints1 = validPoints1(indexPairs(:,1));
matchedPoints2 = validPoints2(indexPairs(:,2));

% Estimate fundamental matrix
[fMatrix, inliers] = estimateFundamentalMatrix(matchedPoints1, matchedPoints2, ...
    'Method', 'RANSAC', 'NumTrials', 2000, 'DistanceThreshold', 1.5);

% Select inlier matches
inlierPoints1 = matchedPoints1(inliers);
inlierPoints2 = matchedPoints2(inliers);

% Stereo Rectification
imageSize = size(leftImgGray);
[t1, t2] = estimateUncalibratedRectification(fMatrix, inlierPoints1.Location, inlierPoints2.Location, imageSize);

% Convert to projective transformations
tform1 = projective2d(t1);
tform2 = projective2d(t2);

% Warp images using projective transformation
leftRectified = imwarp(leftImgGray, tform1, 'OutputView', imref2d(imageSize));
rightRectified = imwarp(rightImgGray, tform2, 'OutputView', imref2d(imageSize));

% Compute disparity map
disparityRange = [0 64]; % Adjust range based on scene
disparityMap = disparitySGM(leftRectified, rightRectified, 'DisparityRange', disparityRange);

% Display depth map
figure;
imshow(disparityMap, [disparityRange(1) disparityRange(2)]);
colormap jet;
colorbar;
title('Depth Map Estimated from Stereo Pair');