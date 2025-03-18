%% Initialization
clc;
clear;
close all;
fd_path = 'Photos/Grid/FD/';
hg_path = 'Photos/Grid/HG/';
%% Load and Resize Images
I1_colour = imresize(imread([fd_path '2.jpg']), 0.15);
I2_colour = imresize(imread([hg_path '2.jpg']), 0.15);

nums = 10; % Number of manually selected points

%% Manual Point Selection - Image 1
figure;
imshow(I1_colour);
hold on;
title('Select Points in Image 1');

img1 = zeros(nums, 2);

for i = 1:nums
    enableDefaultInteractivity(gca);
    [img1(i, 1), img1(i, 2)] = ginput(1);
    plot(img1(i, 1), img1(i, 2), 'rx', 'LineWidth', 1);
    text(img1(i, 1), img1(i, 2), num2str(i), 'FontSize', 14, 'Color', 'red');
end

%% Manual Point Selection - Image 2
figure;
imshow(I2_colour);
hold on;
title('Select Corresponding Points in Image 2');

img2 = zeros(nums, 2);

for i = 1:nums
    enableDefaultInteractivity(gca);
    [img2(i, 1), img2(i, 2)] = ginput(1);
    plot(img2(i, 1), img2(i, 2), 'g+', 'LineWidth', 1);
    text(img2(i, 1), img2(i, 2), num2str(i), 'FontSize', 14, 'Color', 'green');
end

%% Display Matched Features
figure;
showMatchedFeatures(I1_colour, I2_colour, img1, img2, 'montage');
title('Manually Selected Feature Matches');

%% Estimate Homography (Projective Transformation)
[tform, inlierpoints1, inlierpoints2] = estimateGeometricTransform(img1, img2, 'projective');

% Display Inlier Matches
figure;
showMatchedFeatures(I1_colour, I2_colour, inlierpoints1, inlierpoints2, 'montage');
title('Inlier Matches After Homography Estimation');

%% Compute Projected Points
H = tform.T; % Homography matrix

% Convert points to homogeneous coordinates
z_axis = ones(size(img2, 1), 1);
pn1 = [img1, z_axis]; % Points in image 1
pn2 = [img2, z_axis]; % Points in image 2

% Apply transformation to image 1 points
pn1_tr = pn1.'; % Transpose for multiplication
H2 = H.'; % Transpose of transformation matrix

% Project Image 1 points onto Image 2 using H
projected_points = (H2 * pn1_tr).'; 

% Normalize homogeneous coordinates
projected_points(:, 1) = projected_points(:, 1) ./ projected_points(:, 3);
projected_points(:, 2) = projected_points(:, 2) ./ projected_points(:, 3);

%% Compute Mean Squared Error (MSE)
MSE = immse(pn2(:, 1:2), projected_points(:, 1:2));

fprintf('\nThe mean squared error (MSE) is: %0.4f\n', MSE);
