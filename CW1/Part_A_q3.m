%% 3.a

cylinder_normal = load('Data_set/cylinder_papillarray_single.mat');
cylinder_TPU = load('Data_set/cylinder_TPU_papillarray_single.mat');
cylinder_rubber = load('Data_set/cylinder_rubber_papillarray_single.mat');

% Extract the force data from the middle papillae (Index 4 according to diagram)
index = 4; %

cylinder_normal_middle_force = cylinder_normal.sensor_matrices_force(:, (index-1)*3+1:index*3);
cylinder_TPU_middle_force = cylinder_TPU.sensor_matrices_force(:, (index-1)*3+1:index*3);
cylinder_rubber_middle_force = cylinder_rubber.sensor_matrices_force(:, (index-1)*3+1:index*3);

% Create the 3D scatter plot
figure;

scatter3(cylinder_normal_middle_force(:,1), cylinder_normal_middle_force(:,2), cylinder_normal_middle_force(:,3), 'r', 'DisplayName', 'Normal Cylinder');
hold on;
scatter3(cylinder_TPU_middle_force(:,1), cylinder_TPU_middle_force(:,2), cylinder_TPU_middle_force(:,3), 'g', 'DisplayName', 'TPU Cylinder');
scatter3(cylinder_rubber_middle_force(:,1), cylinder_rubber_middle_force(:,2), cylinder_rubber_middle_force(:,3), 'b', 'DisplayName', 'Rubber Cylinder');

xlabel('Force X');
ylabel('Force Y');
zlabel('Force Z');
title('3D Scatter Plot of Middle Papillae Data for Cylinders');
legend;
grid on;

%% 3.b


index = 2; % Corner index

cylinder_normal_corner_force = cylinder_normal.sensor_matrices_force(:, (index-1)*3+1:index*3);
cylinder_TPU_corner_force = cylinder_TPU.sensor_matrices_force(:, (index-1)*3+1:index*3);
cylinder_rubber_corner_force = cylinder_rubber.sensor_matrices_force(:, (index-1)*3+1:index*3);


% Create the 3D scatter plot
figure;

scatter3(cylinder_normal_corner_force(:,1), cylinder_normal_corner_force(:,2), cylinder_normal_corner_force(:,3), 'r', 'DisplayName', 'Normal Cylinder');
hold on;
scatter3(cylinder_TPU_corner_force(:,1), cylinder_TPU_corner_force(:,2), cylinder_TPU_corner_force(:,3), 'g', 'DisplayName', 'TPU Cylinder');
scatter3(cylinder_rubber_corner_force(:,1), cylinder_rubber_corner_force(:,2), cylinder_rubber_corner_force(:,3), 'b', 'DisplayName', 'Rubber Cylinder');

xlabel('Force X');
ylabel('Force Y');
zlabel('Force Z');
title('3D Scatter Plot of Corner Papillae Data for Cylinders');
legend;
grid on;

