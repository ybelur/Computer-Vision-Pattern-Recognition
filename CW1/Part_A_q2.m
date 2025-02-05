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

