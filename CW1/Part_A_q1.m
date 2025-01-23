% Load the data for cylinder and hexagon objects
cylinder_data = load('Data_Set/cylinder_TPU_papillarray_single.mat');
hexagon_data = load('Data_Set/hexagon_TPU_papillarray_single.mat');

% Extract end effector poses
cylinder_poses = cylinder_data.end_effector_poses;
hexagon_poses = hexagon_data.end_effector_poses;

% Extract position data (assuming positions are the first 3 columns)
cylinder_positions = cylinder_poses(:, 1:3);
hexagon_positions = hexagon_poses(:, 1:3);

% Plot the movement trajectories
figure;

% Cylinder trajectory
subplot(1, 2, 1);
plot(cylinder_positions(:, 1), cylinder_positions(:, 2), '-o');
xlabel('X Position');
ylabel('Y Position');
title('Cylinder Trajectory');
grid on;

% Hexagon trajectory
subplot(1, 2, 2);
plot(hexagon_positions(:, 1), hexagon_positions(:, 2), '-o');
xlabel('X Position');
ylabel('Y Position');
title('Hexagon Trajectory');
grid on;

% Make the figure layout clean
sgtitle('Movement Trajectories of End Effector');
