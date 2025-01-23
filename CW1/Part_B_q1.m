%% B.1.a

% Load datasets
cylinder_normal = load('Data_set/cylinder_papillarray_single.mat');
cylinder_rubber = load('Data_set/cylinder_rubber_papillarray_single.mat');
cylinder_TPU = load('Data_set/cylinder_TPU_papillarray_single.mat');

% Extract the force data for the middle papilla , P4: columns 10-12
force_cylinder = cylinder_normal.sensor_matrices_force(:, 10:12);
force_rubber = cylinder_rubber.sensor_matrices_force(:, 10:12); 
force_TPU = cylinder_TPU.sensor_matrices_force(:, 10:12);  

% Combine data and standardise the data
combined_force = [force_cylinder; force_rubber; force_TPU];
standardized_data = (combined_force - mean(combined_force)) ./ std(combined_force);

% PCA
[coeff, score, latent, ~, explained] = pca(standardized_data);

figure;
scatter3(standardized_data(:, 1), standardized_data(:, 2), standardized_data(:, 3), 5, 'k'); % Smaller dots
hold on;
quiver3(0, 0, 0, coeff(1, 1) * 10, coeff(2, 1) * 10, coeff(3, 1) * 10, 'r', 'LineWidth', 2); % PC1
quiver3(0, 0, 0, coeff(1, 2) * 10, coeff(2, 2) * 10, coeff(3, 2) * 10, 'g', 'LineWidth', 2); % PC2
quiver3(0, 0, 0, coeff(1, 3) * 10, coeff(2, 3) * 10, 'b', 'LineWidth', 2); % PC3
xlabel('Force X'); ylabel('Force Y'); zlabel('Force Z');
title('Standardized Data with Principal Components');
legend({'Data', 'PC1', 'PC2', 'PC3'}, 'Location', 'best');

%% B.1.b
reduced_data = score(:, 1:2); % Use the first two principal components
figure;
scatter(reduced_data(1:size(force_cylinder, 1), 1), reduced_data(1:size(force_cylinder, 1), 2), 'r');
hold on;
scatter(reduced_data(size(force_cylinder, 1)+1:size(force_cylinder, 1)+size(force_rubber, 1), 1), ...
        reduced_data(size(force_cylinder, 1)+1:size(force_cylinder, 1)+size(force_rubber, 1), 2), 'g');
scatter(reduced_data(size(force_cylinder, 1)+size(force_rubber, 1)+1:end, 1), ...
        reduced_data(size(force_cylinder, 1)+size(force_rubber, 1)+1:end, 2), 'b');
xlabel('PC1'); ylabel('PC2');
title('Data Reduced to 2D using PCA');
legend({'Cylinder', 'Rubber', 'TPU'}, 'Location', 'best');

%% B.1.c
figure;

numPCs = size(score, 2); 

for i = 1:numPCs
    subplot(numPCs, 1, i);
    scatter(score(:, i), i * ones(size(score(:, i))), 'k', '.'); 
    ylabel(['PC', num2str(i)]);
    xlim([min(score(:, i)) - 1, max(score(:, i)) + 1]); % Adjust x-axis limits
    if i == 1
        title('Data Distribution Across Principal Components');
    end
end

xlabel('Value of Principal Component');

% Display explained variance
disp('Explained Variance (%) by Principal Components:');
disp(explained);

