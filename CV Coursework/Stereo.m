clc; clear; close all;

% Load stereo images (Modify file names accordingly)
leftImg = imread('Photos/Grid/FD/1.jpg');  
rightImg = imread('Photos/Grid/FD/2.jpg'); 

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

% Display original stereo pair
figure;
subplot(2,2,1);
imshow(leftImg);
title('Original Left Image');

subplot(2,2,2);
imshow(rightImg);
title('Original Right Image');

% Stereo Rectification (uncalibrated)
imageSize = size(leftImgGray);
[t1, t2] = estimateUncalibratedRectification(fMatrix, ...
    inlierPoints1.Location, inlierPoints2.Location, imageSize);

% Convert to projective transformations
tform1 = projective2d(t1);
tform2 = projective2d(t2);

% Warp images using projective transformation
leftRectified = imwarp(leftImgGray, tform1, 'OutputView', imref2d(imageSize));
rightRectified = imwarp(rightImgGray, tform2, 'OutputView', imref2d(imageSize));

% Rectify the inlier points as well
inlierPoints1Rect = transformPointsForward(tform1, inlierPoints1.Location);
inlierPoints2Rect = transformPointsForward(tform2, inlierPoints2.Location);

% Display rectified images with epipolar lines through matching points
subplot(2,2,3);
imshow(leftRectified);
hold on;
for i = 1:size(inlierPoints1Rect,1)
    y = inlierPoints1Rect(i,2);
    line([1 size(leftRectified,2)], [y y], 'Color', 'r', 'LineWidth', 1);
end
title('Rectified Left Image with Epipolar Lines');

subplot(2,2,4);
imshow(rightRectified);
hold on;
for i = 1:size(inlierPoints2Rect,1)
    y = inlierPoints2Rect(i,2);
    line([1 size(rightRectified,2)], [y y], 'Color', 'r', 'LineWidth', 1);
end
title('Rectified Right Image with Epipolar Lines');
hold off;
