close all;
clear;
clc;

% Read and prepare image
img = imread('Photos/vanishing.jpg');
padding = 0;
img_padded = padarray(img, [padding, padding], 255);

% Convert to grayscale and threshold
gray_img = rgb2gray(img_padded);
binary_img = imbinarize(gray_img, 80/255);

% Edge detection using Canny
edge_img = edge(binary_img, 'canny', 0.8);

% Compute Hough Transform
[H, theta, rho] = hough(edge_img);

% Detect peaks in the Hough transform
num_peaks = 10;
peak_thresh = ceil(0.3 * max(H(:)));
peaks = houghpeaks(H, num_peaks, 'Threshold', peak_thresh);

% Extract lines from the Hough transform
min_length = 50;
lines = houghlines(edge_img, theta, rho, peaks, 'FillGap', 5, 'MinLength', min_length);

% Plot the original image
figure, imshow(img_padded), hold on
title('Detected Lines and Vanishing Point');

% Helper function to plot lines
plot_lines(lines, size(edge_img));

% Plot fixed vertical line and vanishing point marker
x_vanish = 285.091;
y_vanish = 1973.39;
xline(x_vanish, 'LineWidth', 4, 'Color', 'b');
plot(x_vanish, y_vanish, '.', 'MarkerSize', 50, 'Color', 'c');

hold off;

%% Function to plot lines with extrapolation
function plot_lines(lines, img_size)
    % Group lines based on index ranges if needed
    total_lines = length(lines);
    for k = 1:total_lines
        % Extract the endpoints
        pt1 = lines(k).point1;
        pt2 = lines(k).point2;
        
        % Calculate slope and intercept
        if pt2(1) ~= pt1(1)
            m = (pt2(2) - pt1(2)) / (pt2(1) - pt1(1));
            b = pt1(2) - m * pt1(1);
            % Extrapolate the line across the image width
            x_vals = linspace(1, img_size(2), 500);
            y_vals = m * x_vals + b;
        else
            % Vertical line case
            x_vals = pt1(1) * ones(1, 2);
            y_vals = [1, img_size(1)];
        end
        plot(x_vals, y_vals, 'y-', 'LineWidth', 2);
    end
end
