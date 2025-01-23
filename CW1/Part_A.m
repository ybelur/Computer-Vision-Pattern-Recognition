%% Part 1, Question A: Data Preparation and Visualization

% Load the dataset for the cylinder and hexagon objects
cylinder_file = 'Data_set/hexagon_rubber_papillarray_single.mat';
hexagon_file = 'Data_set/cylinder_rubber_papillarray_single.mat';

load(cylinder_file);
load(hexagon_file);

% Extract relevant variables
cylinder_positions = end_effector_poses;
hexagon_positions = end_effector_poses;

%% Question A.1: Plot movement trajectories
figure;
plot3(cylinder_positions(:, 1), cylinder_positions(:, 2), cylinder_positions(:, 3), 'r', 'LineWidth', 1.5);
hold on;
plot3(hexagon_positions(:, 1), hexagon_positions(:, 2), hexagon_positions(:, 3), 'b', 'LineWidth', 1.5);
grid on;
xlabel('X (m)'); ylabel('Y (m)'); zlabel('Z (m)');
legend('Cylinder', 'Hexagon');
title('Movement Trajectories of End Effector');
view(3);
hold off;

%% Question A.2: Segment data into individual object contacts
% Force data from the force/torque sensor
force_data_cylinder = ft_values(:, 3); % Normal force (Z-axis)

% Find peaks in the normal force to determine contact points
[peaks, indices] = findpeaks(force_data_cylinder, 'MinPeakProminence', 0.5);

% Plot force data with detected peaks
figure;
plot(force_data_cylinder, 'b'); hold on;
plot(indices, peaks, 'ro');
xlabel('Time Index'); ylabel('Force (N)');
title('Normal Force with Detected Contact Points');
legend('Normal Force', 'Contact Points');
hold off;

% Save peaks and indices
save('cylinder_contact_peaks.mat', 'peaks', 'indices');

% Extract tactile sensor data at peak points
tactile_force_data = sensor_matricies_force(indices, :);
tactile_displacement_data = sensor_matricies_displacement(indices, :);

% Save extracted data
save('cylinder_tactile_data.mat', 'tactile_force_data', 'tactile_displacement_data');

%% Question A.3: 3D Scatter Plot for Middle Papillae (P4)
% Middle papillae corresponds to indices 10:12 in the force/displacement data
P4_force_cylinder = tactile_force_data(:, 10:12);

% Load the additional cylinder datasets for TPU and rubber materials
load('cylinder_TPU_papillarray_single.mat');
load('cylinder_rubber_papillarray_single.mat');

% Extract force data for TPU and rubber
force_TPU = sensor_matricies_force(indices, 10:12);
force_rubber = sensor_matricies_force(indices, 10:12);

% Plot 3D scatter for the three materials
figure;
scatter3(P4_force_cylinder(:, 1), P4_force_cylinder(:, 2), P4_force_cylinder(:, 3), 'r', 'filled');
hold on;
scatter3(force_TPU(:, 1), force_TPU(:, 2), force_TPU(:, 3), 'g', 'filled');
scatter3(force_rubber(:, 1), force_rubber(:, 2), force_rubber(:, 3), 'b', 'filled');
grid on;
xlabel('Force X (N)'); ylabel('Force Y (N)'); zlabel('Force Z (N)');
legend('PLA', 'TPU', 'Rubber');
title('3D Scatter Plot of Force Data for Middle Papillae (P4)');
hold off;
