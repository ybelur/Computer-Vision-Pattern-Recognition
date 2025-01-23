%% A.1

cylinder_data = load('Data_Set/cylinder_papillarray_single.mat');
hexagon_data = load('Data_Set/hexagon_papillarray_single.mat');

cylinder_poses = cylinder_data.end_effector_poses;
hexagon_poses = hexagon_data.end_effector_poses;

% Extract position data 
cylinder_positions = cylinder_poses(:, 1:3);
hexagon_positions = hexagon_poses(:, 1:3);


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

sgtitle('Movement Trajectories of End Effector');
