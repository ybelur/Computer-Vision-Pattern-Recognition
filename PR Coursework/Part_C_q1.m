%% C.1.a

% Load the provided .mat files for Oblong TPU and Oblong Rubber objects

% ALL DATA
% oblong_TPU = load('Data_set/oblong_TPU_papillarray_single.mat');
% oblong_rubber = load('Data_set/oblong_rubber_papillarray_single.mat');

% PEAK DATA
oblong_TPU = load('Peak_Data/hexagon_TPU_peak_data.mat');
oblong_rubber = load('Peak_Data/oblong_rubber_peak_data.mat');

% ALL DATA
% oblong_TPU_displacement = oblong_TPU.sensor_matrices_displacement;
% oblong_rubber_displacement = oblong_rubber.sensor_matrices_displacement;

% PEAK DATA
oblong_TPU_displacement = oblong_TPU.peak_tactile_displacement;
oblong_rubber_displacement = oblong_rubber.peak_tactile_displacement;

% Extract the central papillae displacement (P4, index 4)
oblong_TPU_P4 = oblong_TPU_displacement(:, 10:12); % Columns 10-12 for P4 (X, Y, Z)
oblong_rubber_P4 = oblong_rubber_displacement(:, 10:12); % Columns 10-12 for P4

% Combine data and create labels
X = [oblong_TPU_P4; oblong_rubber_P4];
y = [ones(size(oblong_TPU_P4, 1), 1); 2 * ones(size(oblong_rubber_P4, 1), 1)];

%% C.1.b Visualise the tactile displacement with a 3D scatter plot
figure;
scatter3(oblong_TPU_P4(:, 1), oblong_TPU_P4(:, 2), oblong_TPU_P4(:, 3), 'r', 'DisplayName', 'Oblong TPU');
hold on;
scatter3(oblong_rubber_P4(:, 1), oblong_rubber_P4(:, 2), oblong_rubber_P4(:, 3), 'b', 'DisplayName', 'Oblong Rubber');
grid on;
xlabel('Displacement X'); ylabel('Displacement Y'); zlabel('Displacement Z');
legend;
title('3D Scatter Plot of Tactile Displacement for Oblong TPU and Rubber');

%% C.1.c Apply LDA to 2D combinations of D_X, D_Y, and D_Z
combinations = nchoosek(1:3, 2); % All 2D combinations of [X, Y, Z]
figure;
for i = 1:size(combinations, 1)
    subplot(2, 2, i);
    lda_model = fitcdiscr(X(:, combinations(i, :)), y);
    lda_predictions = predict(lda_model, X(:, combinations(i, :)));
    
    gscatter(X(:, combinations(i, 1)), X(:, combinations(i, 2)), lda_predictions, 'rb', 'ox');
    xlabel(['D_' char('X' + combinations(i, 1) - 1)]);
    ylabel(['D_' char('X' + combinations(i, 2) - 1)]);
    title(['LDA on ', ['D_' char('X' + combinations(i, 1) - 1)], ' and ', ['D_' char('X' + combinations(i, 2) - 1)]]);
end


%% C.1.d - Reduce to 2D and replot

% Reducing the data to 2 Dimensions and Re-plot

% Combine all displacement data for TPU and Rubber
displacement_data = [oblong_TPU_displacement; oblong_rubber_displacement];

% Create class labels (0 = TPU, 1 = Rubber)
labels = [zeros(size(oblong_TPU_displacement, 1), 1); ones(size(oblong_rubber_displacement, 1), 1)];

% Apply LDA
lda_model = fitcdiscr(displacement_data, labels);

% Project data into 2D space
lda_2d = lda_model.X .* lda_model.Coeffs(1,2).Linear';

% Extract class-wise projections
lda_tpu = lda_2d(labels == 0, :);
lda_rub = lda_2d(labels == 1, :);

% Plot the 2D LDA result
figure;
scatter(lda_tpu(:,1), lda_tpu(:,2), 5, 'r', 'filled'); % Oblong TPU in red
hold on;
scatter(lda_rub(:,1), lda_rub(:,2), 5, 'b', 'filled'); % Oblong Rubber in blue

% Plot the discrimination line
coeff = lda_model.Coeffs(1,2).Linear;
k = -coeff(1)/coeff(2); % Slope
x_range = linspace(min(lda_2d(:,1)), max(lda_2d(:,1)), 100);
y_range = k * x_range; % Line equation
plot(x_range, y_range, 'k', 'LineWidth', 2); % Black discrimination line

xlabel('LD1');
ylabel('LD2');
title('LDA 2D Projection with Discrimination Line');
legend('Oblong TPU', 'Oblong Rubber', 'Discrimination Line');
grid on;
hold off;

%% C.3.d.i - 3d Plot with plane

% 3D plot with discrimination plane
% Extract 3D displacement data
D_X = displacement_data(:,1);
D_Y = displacement_data(:,2);
D_Z = displacement_data(:,3);

% Plot the 3D displacement points
figure;
scatter3(D_X(labels == 0), D_Y(labels == 0), D_Z(labels == 0), 5, 'r', 'filled'); % TPU
hold on;
scatter3(D_X(labels == 1), D_Y(labels == 1), D_Z(labels == 1), 5, 'b', 'filled'); % Rubber

% Plot the discrimination plane
% Use coefficients of the LDA model
plane_coeff = lda_model.Coeffs(1,2).Linear; % [a, b, c] for ax + by + cz = d
a = plane_coeff(1);
b = plane_coeff(2);
c = plane_coeff(3);
d = lda_model.Coeffs(1,2).Const; % Plane offset

% Define the range for the plane
[x_plane, y_plane] = meshgrid(linspace(min(D_X), max(D_X), 30), linspace(min(D_Y), max(D_Y), 30));
z_plane = -(a*x_plane + b*y_plane + d)/c;

% Plot the plane
surf(x_plane, y_plane, z_plane, 'FaceAlpha', 0.5, 'EdgeColor', 'none', 'FaceColor', 'k');

% Customize the plot
xlabel('Displacement X');
ylabel('Displacement Y');
zlabel('Displacement Z');
title('3D LDA Projection with Discrimination Plane');
legend('Oblong TPU', 'Oblong Rubber', 'Discrimination Plane');
grid on;
hold off;
