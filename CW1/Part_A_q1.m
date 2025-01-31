%% A.1

cylinder_data_normal = load('Data_Set/cylinder_papillarray_single.mat');
cylinder_data_rubber = load('Data_Set/cylinder_rubber_papillarray_single.mat');
cylinder_data_TPU = load('Data_Set/cylinder_TPU_papillarray_single.mat');

hexagon_data_normal = load('Data_Set/hexagon_papillarray_single.mat');
hexagon_data_rubber = load('Data_Set/hexagon_rubber_papillarray_single.mat');
hexagon_data_TPU = load('Data_Set/hexagon_TPU_papillarray_single.mat');

cylinder_poses_normal = cylinder_data_normal.end_effector_poses;
cylinder_poses_rubber = cylinder_data_rubber.end_effector_poses;
cylinder_poses_TPU = cylinder_data_TPU.end_effector_poses;

hexagon_poses_normal = hexagon_data_normal.end_effector_poses;
hexagon_poses_rubber = hexagon_data_rubber.end_effector_poses;
hexagon_poses_TPU = hexagon_data_TPU.end_effector_poses;

% Extract position data 
cylinder_positions_normal = cylinder_poses_normal(:, 1:3);
cylinder_positions_rubber = cylinder_poses_rubber(:, 1:3);
cylinder_positions_TPU = cylinder_poses_TPU(:, 1:3);


hexagon_positions_normal = hexagon_poses_normal(:, 1:3);
hexagon_positions_rubber = hexagon_poses_rubber(:, 1:3);
hexagon_positions_TPU = hexagon_poses_TPU(:, 1:3);


figure;

% Define common axis limits
x_limits = [-0.16, 0.07];
y_limits = [0.39, 0.555];

subplot(2, 3, 1);
scatter(cylinder_positions_normal(:, 1), cylinder_positions_normal(:, 2), 'filled');
title('Cylinder Normal');
xlabel('X');
ylabel('Y');
xlim(x_limits);
ylim(y_limits);

subplot(2, 3, 2);
scatter(cylinder_positions_rubber(:, 1), cylinder_positions_rubber(:, 2), 'filled');
title('Cylinder Rubber');
xlabel('X');
ylabel('Y');
xlim(x_limits);
ylim(y_limits);

subplot(2, 3, 3);
scatter(cylinder_positions_TPU(:, 1), cylinder_positions_TPU(:, 2), 'filled');
title('Cylinder TPU');
xlabel('X');
ylabel('Y');
xlim(x_limits);
ylim(y_limits);

subplot(2, 3, 4);
scatter(hexagon_positions_normal(:, 1), hexagon_positions_normal(:, 2), 'filled');
title('Hexagon Normal');
xlabel('X');
ylabel('Y');
xlim(x_limits);
ylim(y_limits);

subplot(2, 3, 5);
scatter(hexagon_positions_rubber(:, 1), hexagon_positions_rubber(:, 2), 'filled');
title('Hexagon Rubber');
xlabel('X');
ylabel('Y');
xlim(x_limits);
ylim(y_limits);

subplot(2, 3, 6);
scatter(hexagon_positions_TPU(:, 1), hexagon_positions_TPU(:, 2), 'filled');
title('Hexagon TPU');
xlabel('X');
ylabel('Y');
xlim(x_limits);
ylim(y_limits);

% suptitle('End Effector Positions');

