% Load the data files

% ALL DATA
% data_cylinder = load('Data_set/cylinder_papillarray_single.mat');
% data_rubber = load('Data_set/cylinder_rubber_papillarray_single.mat');
% data_TPU = load('Data_set/cylinder_TPU_papillarray_single.mat');

% PEAK DATA
data_cylinder = load('Peak_Data/cylinder_peak_data.mat');
data_rubber = load('Peak_Data/cylinder_rubber_peak_data.mat');
data_TPU = load('Peak_Data/cylinder_TPU_peak_data.mat');

% Extract force data for all 9 papillae

% ALL DATA
% force_cylinder = data_cylinder.sensor_matrices_force; 
% force_rubber = data_rubber.sensor_matrices_force;  
% force_TPU = data_TPU.sensor_matrices_force;

% PEAK DATA
force_cylinder = data_cylinder.peak_tactile_force; 
force_rubber = data_rubber.peak_tactile_force;  
force_TPU = data_TPU.peak_tactile_force;

% Combine and standardise the data
combined_force = [force_cylinder; force_rubber; force_TPU];
standardized_data = (combined_force - mean(combined_force, 1)) ./ std(combined_force, 1);

% Perform PCA
[coeff, score, latent, tsquared, explained] = pca(standardized_data);

% Plot Scree Plot
figure;
plot(latent, 'o-', 'LineWidth', 2);
xlabel('Principal Component');
ylabel('Eigenvalue');
title('Scree Plot for PCA Analysis');
grid on;


%% B.2.b 
figure;
for i = 1:3
    subplot(3, 1, i);
    scatter(score(:, i), i * ones(size(score(:, i))), 'k', '.'); 
    ylabel(['PC', num2str(i)]);
    xlim([min(score(:, i)) - 1, max(score(:, i)) + 1]); % Adjust x-axis limits
    if i == 1
        title('1D Number Lines for Principal Components');
    end
end
xlabel('Value of Principal Component');

%% B.2.c
reduced_data = score(:, 1:2);
figure;
scatter(reduced_data(1:size(force_cylinder, 1), 1), reduced_data(1:size(force_cylinder, 1), 2), 'r', 'filled');
hold on;
scatter(reduced_data(size(force_cylinder, 1)+1:size(force_cylinder, 1)+size(force_rubber, 1), 1), ...
        reduced_data(size(force_cylinder, 1)+1:size(force_cylinder, 1)+size(force_rubber, 1), 2), 'g', 'filled');
scatter(reduced_data(size(force_cylinder, 1)+size(force_rubber, 1)+1:end, 1), ...
        reduced_data(size(force_cylinder, 1)+size(force_rubber, 1)+1:end, 2), 'b', 'filled');
xlabel('PC1');
ylabel('PC2');
title('Data Reduced to 2 Dimensions using PCA');
legend({'Cylinder', 'Rubber', 'TPU'}, 'Location', 'best');
grid on;

% Part d: Comment
disp('Comments on PCA Analysis:');
disp('- The scree plot shows how much variance each principal component explains.');
disp('- The first few components capture the majority of variance, indicating dimensionality reduction is effective.');
disp('- Using all nine papillae provides richer data for analysis compared to a single papilla (P4), but also increases complexity.');
disp('- The reduced 2D visualization shows clear separation between object types, highlighting PCA effectiveness.');
