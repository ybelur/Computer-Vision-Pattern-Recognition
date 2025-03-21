clc;
clear;
close all;
function find_correspondence(fd_images, hg_images)
    
    % Ensure the sets have the same number of images
    numImages = min(length(fd_images), length(hg_images));

    for i = 1:numImages
        % Read images
        imgFD = imread(fd_images{i});
        imgHG = imread(hg_images{i});

        % Convert to grayscale if necessary
        if size(imgFD, 3) == 3
            imgFD = rgb2gray(imgFD);
        end
        if size(imgHG, 3) == 3
            imgHG = rgb2gray(imgHG);
        end

        % Detect features and extract descriptors
        pointsFD = detectSURFFeatures(imgFD);
        pointsHG = detectSURFFeatures(imgHG);
        
        % pointsFD = detectKAZEFeatures(imgFD);
        % pointsHG = detectKAZEFeatures(imgHG);

        [featuresFD, validPointsFD] = extractFeatures(imgFD, pointsFD);
        [featuresHG, validPointsHG] = extractFeatures(imgHG, pointsHG);

        % Match features
        indexPairs = matchFeatures(featuresFD, featuresHG);

        % Get matching points
        matchedPointsFD = validPointsFD(indexPairs(:,1), :);
        matchedPointsHG = validPointsHG(indexPairs(:,2), :);
        % Display matches without lines
        figure;
        showMatchedFeatures(imgFD, imgHG, matchedPointsFD, matchedPointsHG, 'montage', 'PlotOptions', {'r.','g.','y--'});
        title(['Matched Features between FD and HG images - Pair ', num2str(i)]);
    end
end

fd_path = 'Photos/Grid/FD/';
hg_path = 'Photos/Grid/HG/';

fd_images = { [fd_path '1.jpg'], 
              [fd_path '2.jpg'], 
              [fd_path '3.jpg'], 
              [fd_path '4.jpg'], 
              [fd_path '5.jpg'], 
              [fd_path '6.jpg'] };  % List your FD images

hg_images = { [hg_path '1.jpg'], 
              [hg_path '2.jpg'], 
              [hg_path '3.jpg'], 
              [hg_path '4.jpg'], 
              [hg_path '5.jpg'], 
              [hg_path '6.jpg'] };  % List your HG images

% fd_images = { ['5.1.jpg'] }
% hg_images = { ['5.2.jpg'] }

find_correspondence(fd_images, hg_images);