% %% A.2.a
% cylinder_data = load('Data_set/cylinder_papillarray_single.mat');
% hexagon_data = load('Data_set/hexagon_papillarray_single.mat');
% 
% cylinder_forces = cylinder_data.ft_values; % [1x3] force vector
% hexagon_forces = hexagon_data.ft_values;  % [1x3] force vector
% 
% % Extract tactile sensor data 
% cylinder_tactile_force = cylinder_data.sensor_matrices_force; % Adjust based on dataset structure
% cylinder_tactile_displacement = cylinder_data.sensor_matrices_displacement;
% hexagon_tactile_force = hexagon_data.sensor_matrices_force;
% hexagon_tactile_displacement = hexagon_data.sensor_matrices_displacement;
% 
% % Extract Z-force 
% cylinder_z_force = cylinder_forces(:, 3); % Assuming Z is the 3rd column
% hexagon_z_force = hexagon_forces(:, 3);
% 
% % Identify peaks of maximum normal contact force
% [cylinder_peaks, cylinder_indices] = findpeaks(cylinder_z_force, 'MinPeakProminence', 0.5);
% [hexagon_peaks, hexagon_indices] = findpeaks(hexagon_z_force, 'MinPeakProminence', 0.5);
% 
% % Extract sensor data at peak indices
% cylinder_peak_tactile_force = cylinder_tactile_force(cylinder_indices, :);
% cylinder_peak_tactile_displacement = cylinder_tactile_displacement(cylinder_indices, :);
% cylinder_peak_ft_data = cylinder_forces(cylinder_indices, :);
% 
% hexagon_peak_tactile_force = hexagon_tactile_force(hexagon_indices, :);
% hexagon_peak_tactile_displacement = hexagon_tactile_displacement(hexagon_indices, :);
% hexagon_peak_ft_data = hexagon_forces(hexagon_indices, :);
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
% %% A.2.b
% 
% % Save the extracted data
% save('cylinder_peak_data.mat', 'cylinder_peaks', 'cylinder_indices', 'cylinder_peak_tactile_force', 'cylinder_peak_tactile_displacement', 'cylinder_peak_ft_data');
% save('hexagon_peak_data.mat', 'hexagon_peaks', 'hexagon_indices', 'hexagon_peak_tactile_force', 'hexagon_peak_tactile_displacement', 'hexagon_peak_ft_data');
% 
% %% A.2.c
% 
% % Load the extracted peak data for cylinder and hexagon
% cylinder_peak_data = load('cylinder_peak_data.mat');
% hexagon_peak_data = load('hexagon_peak_data.mat');
% 
% % Extract relevant data
% cylinder_peak_indices = cylinder_peak_data.cylinder_indices;
% hexagon_peak_indices = hexagon_peak_data.hexagon_indices;
% 
% % Extract tactile force, displacement, and force/torque sensor data at peak indices
% cylinder_peak_tactile_force = cylinder_tactile_force(cylinder_peak_indices, :);
% cylinder_peak_tactile_displacement = cylinder_tactile_displacement(cylinder_peak_indices, :);
% cylinder_peak_ft_data = cylinder_forces(cylinder_peak_indices, :);
% 
% hexagon_peak_tactile_force = hexagon_tactile_force(hexagon_peak_indices, :);
% hexagon_peak_tactile_displacement = hexagon_tactile_displacement(hexagon_peak_indices, :);
% hexagon_peak_ft_data = hexagon_forces(hexagon_peak_indices, :);
% 
% % Save the extracted tactile and force data for future processing
% save('cylinder_peak_data.mat', 'cylinder_peak_tactile_force', 'cylinder_peak_tactile_displacement', 'cylinder_peak_ft_data', '-append');
% save('hexagon_peak_data.mat', 'hexagon_peak_tactile_force', 'hexagon_peak_tactile_displacement', 'hexagon_peak_ft_data', '-append');
% 
% % Display confirmation message
% disp('Tactile sensor and force/torque data at peaks have been extracted and saved.');
% 
% % Plot the data
% 
% % Plot tactile force data for cylinder
% figure;
% subplot(2, 1, 1);
% plot(cylinder_peak_tactile_force);
% xlabel('Time Index');
% ylabel('Tactile Force (Cylinder)');
% title('Cylinder - Tactile Force at Peaks');
% grid on;
% 
% % Plot tactile force data for hexagon
% 
% subplot(2, 1, 2);
% plot(hexagon_peak_tactile_force);
% xlabel('Time Index');
% ylabel('Tactile Force (Hexagon)');
% title('Hexagon - Tactile Force at Peaks');
% grid on;
% 
% 

%% A.2.a - Process all 9 objects

% List of object files
object_files = { 
    'Data_Set/cylinder_papillarray_single.mat', 
    'Data_Set/hexagon_papillarray_single.mat', 
    'Data_Set/oblong_papillarray_single.mat', 
    'Data_Set/cylinder_rubber_papillarray_single.mat', 
    'Data_Set/hexagon_rubber_papillarray_single.mat', 
    'Data_Set/oblong_rubber_papillarray_single.mat', 
    'Data_Set/cylinder_TPU_papillarray_single.mat', 
    'Data_Set/hexagon_TPU_papillarray_single.mat', 
    'Data_Set/oblong_TPU_papillarray_single.mat'
};

% Structure to hold data for all objects
peak_data = struct();

for i = 1:length(object_files)
    obj_name = erase(object_files{i}, {'Data_Set/', '_papillarray_single.mat', '.mat'}); % Remove extra text
    data = load(object_files{i});
    
    % Extract relevant data
    forces = data.ft_values; % [Nx3] force vector
    tactile_force = data.sensor_matrices_force;
    tactile_displacement = data.sensor_matrices_displacement;
    
    % Extract Z-force
    z_force = forces(:, 3);
    
    % Identify peaks
    [peaks, indices] = findpeaks(z_force, 'MinPeakProminence', 0.35);
    
    % Extract sensor data at peak indices
    peak_tactile_force = tactile_force(indices, :);
    peak_tactile_displacement = tactile_displacement(indices, :);
    peak_ft_data = forces(indices, :);
    
    % Store data in structure
    peak_data.(obj_name).peaks = peaks;
    peak_data.(obj_name).indices = indices;
    peak_data.(obj_name).peak_tactile_force = peak_tactile_force;
    peak_data.(obj_name).peak_tactile_displacement = peak_tactile_displacement;
    peak_data.(obj_name).peak_ft_data = peak_ft_data;
    
    % Save the extracted data for each object
    save(['Peak_Data/' obj_name '_peak_data.mat'], 'peaks', 'indices', 'peak_tactile_force', 'peak_tactile_displacement', 'peak_ft_data');
end

% Save all peak data into one file for easy access
save('Peak_data/all_objects_peak_data.mat', 'peak_data');

%% A.2.b - Plot peaks for each object
figure;
for i = 1:length(object_files)
    obj_name = erase(object_files{i}, {'Data_Set/', '_papillarray_single.mat', '.mat'});
    subplot(3, 3, i);
    plot(peak_data.(obj_name).indices, peak_data.(obj_name).peaks, 'ro');
    hold on;
    plot(1:length(peak_data.(obj_name).peaks), peak_data.(obj_name).peaks, 'b');
    xlabel('Time Index');
    ylabel(['Normal Contact Force (' obj_name ')']);
    title([obj_name ' - Force Peaks']);
    grid on;
end

