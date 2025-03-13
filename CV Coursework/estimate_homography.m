function estimate_homography(hg_images)
    numImages = length(hg_images) - 1; % Number of image pairs

    for i = 1:numImages
        img1 = imread(hg_images{i});
        img2 = imread(hg_images{i+1});

        % Convert to grayscale if necessary
        if size(img1, 3) == 3
            img1 = rgb2gray(img1);
        end
        if size(img2, 3) == 3
            img2 = rgb2gray(img2);
        end

        % Detect features and extract descriptors
        points1 = detectSURFFeatures(img1);
        points2 = detectSURFFeatures(img2);

        [features1, validPoints1] = extractFeatures(img1, points1);
        [features2, validPoints2] = extractFeatures(img2, points2);

        % Match features
        indexPairs = matchFeatures(features1, features2);

        % Get matching points
        matchedPoints1 = validPoints1(indexPairs(:,1), :);
        matchedPoints2 = validPoints2(indexPairs(:,2), :);

        % Estimate homography matrix using RANSAC
        [H, inliers] = estimateGeometricTransform2D(matchedPoints1, matchedPoints2, 'projective', 'MaxNumTrials', 2000, 'Confidence', 99);

        % Transform points from img1 to img2 using H
        transformedPoints = transformPointsForward(H, matchedPoints1.Location);

        % Visualize correspondences
        figure;
        showMatchedFeatures(img1, img2, matchedPoints1, matchedPoints2, 'montage');
        title(['Matched Keypoints - Pair ', num2str(i)]);

        % Visualize projected keypoints
        figure;
        imshow(img2); hold on;
        plot(transformedPoints(:,1), transformedPoints(:,2), 'rx', 'MarkerSize', 10, 'LineWidth', 2);
        title(['Projected Keypoints from Image ', num2str(i), ' to Image ', num2str(i+1)]);

        % Display homography matrix
        disp(['Estimated Homography Matrix for Image Pair ', num2str(i), ' - ', num2str(i+1), ':']);
        disp(H.T);
    end
end