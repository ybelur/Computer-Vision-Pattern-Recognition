function find_correspondence(fd_images, hg_images)
    % FIND_CORRESPONDENCE Matches features between FD and HG image sets
    % fd_images: cell array of file paths to FD images
    % hg_images: cell array of file paths to HG images
    
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
        
        [featuresFD, validPointsFD] = extractFeatures(imgFD, pointsFD);
        [featuresHG, validPointsHG] = extractFeatures(imgHG, pointsHG);

        % Match features
        indexPairs = matchFeatures(featuresFD, featuresHG);

        % Get matching points
        matchedPointsFD = validPointsFD(indexPairs(:,1), :);
        matchedPointsHG = validPointsHG(indexPairs(:,2), :);

        % Display matches
        figure;
        showMatchedFeatures(imgFD, imgHG, matchedPointsFD, matchedPointsHG, 'montage');
        title(['Matched Features between FD and HG images - Pair ', num2str(i)]);
    end
end

fd_path = 'Photos/FD/';
hg_path = 'Photos/HG/';

fd_images = { [fd_path 'Front_On.jpg'], 
              [fd_path 'Left_Side.jpg'], 
              [fd_path 'Right_Side.jpg'], 
              [fd_path 'Top_Down_Front_On.jpg'], 
              [fd_path 'Top_Down_Left_Side.jpg'], 
              [fd_path 'Top_Down_Right_Side.jpg'] };  % List your FD images

hg_images = { [hg_path 'Front_On.jpg'], 
              [hg_path 'Left_Side.jpg'], 
              [hg_path 'Right_Side.jpg'], 
              [hg_path 'Top_Down_Front_On.jpg'], 
              [hg_path 'Top_Down_Left_Side.jpg'], 
              [hg_path 'Top_Down_Right_Side.jpg'] };  % List your HG images


find_correspondence(fd_images, hg_images);