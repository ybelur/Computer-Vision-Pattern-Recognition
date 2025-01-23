% % Load the data for cylinder and hexagon objects
% cylinder_data = load('Data_Set/cylinder_papillarray_single.mat');
% hexagon_data = load('Data_Set/hexagon_papillarray_single.mat');
% 
% % Extract force/torque sensor readings
% cylinder_forces = cylinder_data.ft_values; % [1x3] force vector
% hexagon_forces = hexagon_data.ft_values;  % [1x3] force vector
% 
% % Extract Z-force (normal contact force)
% cylinder_z_force = cylinder_forces(:, 3); % Assuming Z is the 3rd column
% hexagon_z_force = hexagon_forces(:, 3);
% 
% % Identify peaks of maximum normal contact force for cylinder
% [cylinder_peaks, cylinder_indices] = findpeaks(cylinder_z_force, 'MinPeakProminence', 0.5);
% 
% % Identify peaks of maximum normal contact force for hexagon
% [hexagon_peaks, hexagon_indices] = findpeaks(hexagon_z_force, 'MinPeakProminence', 0.5);
% 
% % Plot Z-force with peaks for Cylinder
% figure;
% subplot(2, 1, 1);
% plot(cylinder_z_force, 'b');
% hold on;
% plot(cylinder_indices, cylinder_peaks, 'ro');
% xlabel('Time Index');
% ylabel('Normal Contact Force (Cylinder)');
% title('Cylinder - Normal Contact Force Peaks');
% grid on;
% 
% % Plot Z-force with peaks for Hexagon
% subplot(2, 1, 2);
% plot(hexagon_z_force, 'g');
% hold on;
% plot(hexagon_indices, hexagon_peaks, 'ro');
% xlabel('Time Index');
% ylabel('Normal Contact Force (Hexagon)');
% title('Hexagon - Normal Contact Force Peaks');
% grid on;
% 
% % Save the peaks and indices for each object
% cylinder_peak_data = table(cylinder_indices, cylinder_peaks, 'VariableNames', {'Index', 'Force'});
% hexagon_peak_data = table(hexagon_indices, hexagon_peaks, 'VariableNames', {'Index', 'Force'});
% 
% % Save the data to .mat files for later use
% save('cylinder_peak_data.mat', 'cylinder_peak_data');
% save('hexagon_peak_data.mat', 'hexagon_peak_data');

% Load the data for cylinder and hexagon objects
cylinder_data = load('Data_set/cylinder_papillarray_single.mat');
hexagon_data = load('Data_set/hexagon_papillarray_single.mat');

% Extract force/torque sensor readings
cylinder_forces = cylinder_data.ft_values; % [1x3] force vector
hexagon_forces = hexagon_data.ft_values;  % [1x3] force vector

% Extract tactile sensor data (force and displacement)
cylinder_tactile_force = cylinder_data.sensor_matrices_force; % Adjust based on dataset structure
cylinder_tactile_displacement = cylinder_data.sensor_matrices_displacement;
hexagon_tactile_force = hexagon_data.sensor_matrices_force;
hexagon_tactile_displacement = hexagon_data.sensor_matrices_displacement;

% Extract Z-force (normal contact force)
cylinder_z_force = cylinder_forces(:, 3); % Assuming Z is the 3rd column
hexagon_z_force = hexagon_forces(:, 3);

% Identify peaks of maximum normal contact force for cylinder
[cylinder_peaks, cylinder_indices] = findpeaks(cylinder_z_force, 'MinPeakProminence', 0.5);

% Identify peaks of maximum normal contact force for hexagon
[hexagon_peaks, hexagon_indices] = findpeaks(hexagon_z_force, 'MinPeakProminence', 0.5);

% Extract sensor data at peak indices
cylinder_peak_tactile_force = cylinder_tactile_force(cylinder_indices, :);
cylinder_peak_tactile_displacement = cylinder_tactile_displacement(cylinder_indices, :);
cylinder_peak_ft_data = cylinder_forces(cylinder_indices, :);

hexagon_peak_tactile_force = hexagon_tactile_force(hexagon_indices, :);
hexagon_peak_tactile_displacement = hexagon_tactile_displacement(hexagon_indices, :);
hexagon_peak_ft_data = hexagon_forces(hexagon_indices, :);

% Save the extracted data
save('cylinder_peak_data.mat', 'cylinder_peaks', 'cylinder_indices', 'cylinder_peak_tactile_force', 'cylinder_peak_tactile_displacement', 'cylinder_peak_ft_data');
save('hexagon_peak_data.mat', 'hexagon_peaks', 'hexagon_indices', 'hexagon_peak_tactile_force', 'hexagon_peak_tactile_displacement', 'hexagon_peak_ft_data');

% Plot Z-force with peaks for Cylinder
figure;
subplot(2, 1, 1);
plot(cylinder_z_force, 'b');
hold on;
plot(cylinder_indices, cylinder_peaks, 'ro');
xlabel('Time Index');
ylabel('Normal Contact Force (Cylinder)');
title('Cylinder - Normal Contact Force Peaks');
grid on;

% Plot Z-force with peaks for Hexagon
subplot(2, 1, 2);
plot(hexagon_z_force, 'g');
hold on;
plot(hexagon_indices, hexagon_peaks, 'ro');
xlabel('Time Index');
ylabel('Normal Contact Force (Hexagon)');
title('Hexagon - Normal Contact Force Peaks');
grid on;
