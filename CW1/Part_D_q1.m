%% D.1.a

% Load the oblong object datasets
data_TPU = load('Data_set/hexagon_TPU_papillarray_single.mat'); % TPU material
data_rubber = load('Data_set/oblong_rubber_papillarray_single.mat'); % Rubber material
data_PLA = load('Data_set/oblong_papillarray_single.mat'); % PLA material

% Extract central papillae data (P4)
TPU_displacement = data_TPU.sensor_matrices_displacement(:, 10:12); % Columns for P4 (force)
rubber_displacement = data_rubber.sensor_matrices_displacement(:, 10:12);
PLA_displacement = data_PLA.sensor_matrices_displacement(:, 10:12);

% Combine data and create labels
data = [TPU_displacement; rubber_displacement; PLA_force];
labels = [repmat("TPU", size(TPU_displacement, 1), 1);
          repmat("Rubber", size(rubber_displacement, 1), 1);
          repmat("PLA", size(PLA_force, 1), 1)];

% Scatter plot of the central papillae data
figure;
scatter3(TPU_displacement(:, 1), TPU_displacement(:, 2), TPU_displacement(:, 3), 'r', 'DisplayName', 'TPU');
hold on;
scatter3(rubber_displacement(:, 1), rubber_displacement(:, 2), rubber_displacement(:, 3), 'g', 'DisplayName', 'Rubber');
scatter3(PLA_displacement(:, 1), PLA_displacement(:, 2), PLA_displacement(:, 3), 'b', 'DisplayName', 'PLA');
hold off;
title('Scatter Plot of Central Papillae Data for Oblong Objects');
xlabel('Force X'); ylabel('Force Y'); zlabel('Force Z');
legend;
grid on;

%% D.1.b - K-means Clustering in 3D (Euclidean Metric)

% Apply K-means clustering
k = 3; % Number of clusters
[idx, centroids] = kmeans(data, k, 'Distance', 'sqeuclidean', 'Replicates', 10);

% Define a colormap for clusters
cmap = lines(k); % Generate k distinct colors

% Visualize clustering results in 3D
figure;
hold on;
for i = 1:k
    scatter3(data(idx == i, 1), data(idx == i, 2), data(idx == i, 3), ...
             36, cmap(i, :), 'filled', 'DisplayName', ['Cluster ' num2str(i)]);
end

% Plot centroids after data points to ensure they are on top
scatter3(centroids(:, 1), centroids(:, 2), centroids(:, 3), ...
         200, 'k', 'filled', 'DisplayName', 'Centroids');
hold off;

title('K-means Clustering of Central Papillae Data (Euclidean Metric)');
xlabel('Force X'); ylabel('Force Y'); zlabel('Force Z');
legend('Location', 'best');
view(3);
grid on;

% Evaluate clustering results
disp('Clustering Results (Euclidean Metric):');
for i = 1:k
    fprintf('Cluster %d contains %.2f%% of data points.\n', i, ...
            sum(idx == i) / length(idx) * 100);
end

%% D.1.c - K-means Clustering with cosine Metric in 3D

% Apply K-means clustering with a different distance metric
[idx_alt, centroids_alt] = kmeans(data, k, 'Distance', 'cityblock', 'Replicates', 10);

% Define a colormap for clusters
cmap_alt = lines(k); % Generate k distinct colors

% Visualize clustering results with the new metric in 3D
figure;
hold on;
for i = 1:k
    scatter3(data(idx_alt == i, 1), data(idx_alt == i, 2), data(idx_alt == i, 3), ...
             36, cmap_alt(i, :), 'filled', 'DisplayName', ['Cluster ' num2str(i)]);
end

% Plot centroids after data points to ensure they are on top
scatter3(centroids_alt(:, 1), centroids_alt(:, 2), centroids_alt(:, 3), ...
         200, 'k', 'filled', 'DisplayName', 'Centroids');
hold off;

title('K-means Clustering of Central Papillae Data (Cosine Metric)');
xlabel('Force X'); ylabel('Force Y'); zlabel('Force Z');
legend('Location', 'best');
view(3);
grid on;

% Evaluate clustering results with the new metric
disp('Clustering Results (Cityblock Metric):');
for i = 1:k
    fprintf('Cluster %d contains %.2f%% of data points.\n', i, ...
            sum(idx_alt == i) / length(idx_alt) * 100);
end
