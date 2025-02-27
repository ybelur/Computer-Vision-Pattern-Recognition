%% Question D.2
% Load the data files
% data_cylinder = load('/Users/tamamabibi/Downloads/cylinder_peak_data.mat');
% data_rubber = load('/Users/tamamabibi/Downloads/cylinder_rubber_peak_data.mat');
% peak_data_TPU = load('/Users/tamamabibi/Downloads/cylinder_TPU_peak_data.mat');

% ALL DATA
% data_cylinder = load('Data_set/oblong_papillarray_single.mat');
% data_rubber = load('Data_set/oblong_rubber_papillarray_single.mat');
% data_TPU = load('Data_set/oblong_TPU_papillarray_single.mat');

% 
% % PEAK DATA
data_cylinder = load('Peak_Data/cylinder_peak_data.mat');
data_rubber = load('Peak_Data/cylinder_rubber_peak_data.mat');
data_TPU = load('Peak_Data/cylinder_TPU_peak_data.mat');


% Extract force data for all 9 papillae

% ALL DATA
% displacement_cylinder = data_cylinder.sensor_matrices_displacement;
% displacement_rubber = data_rubber.sensor_matrices_displacement;
% displacement_TPU = data_TPU.sensor_matrices_displacement;

% PEAK DATA
displacement_cylinder = data_cylinder.peak_tactile_displacement;
displacement_rubber = data_rubber.peak_tactile_displacement;
displacement_TPU = data_TPU.peak_tactile_displacement;

% Combine and standardise the data
combined_displacement = [displacement_cylinder; displacement_rubber; displacement_TPU];
standardized_data = (combined_displacement - mean(combined_displacement, 1)) ./ std(combined_displacement, 1);

% Perform PCA
[coeff, score, latent, tsquared, explained] = pca(standardized_data);


%%  a)
% PCA-Reduced data
reduced_data = score(:, 1:2);
% Labels for the classes: Cylinder = 1, Rubber = 2, TPU = 3
num_samples_cylinder = size(displacement_cylinder, 1);
num_samples_rubber = size(displacement_rubber, 1);
num_samples_TPU = size(displacement_TPU, 1);
labels = [ones(num_samples_cylinder, 1); 
          2 * ones(num_samples_rubber, 1); 
          3 * ones(num_samples_TPU, 1)];

% Split data into training and test sets (80% training, 20% test)
rng(1); % For reproducibility
cv = cvpartition(labels, 'HoldOut', 0.2);
train_idx = training(cv);
test_idx = test(cv);

X_train = reduced_data(train_idx, :);
X_train = round(X_train, 2);

y_train = labels(train_idx);
y_train = round(y_train, 2);

X_test = reduced_data(test_idx, :);
y_test = labels(test_idx);

% Train bagged decision trees (ensemble)
num_trees = 3; % Number of trees in the bagging ensemble
bagged_model = TreeBagger(num_trees, X_train, y_train, ...
    'OOBPrediction', 'On', ...
    'Method', 'classification', ...
    'OOBPredictorImportance', 'on', ...
    'MinLeafSize', 30);

%% b. Visualize two generated decision trees
view(bagged_model.Trees{1}, 'Mode', 'graph'); 
view(bagged_model.Trees{2}, 'Mode', 'graph');

%% c. Run the trained model with the test data
% Predict the test data
[y_predicted, scores] = bagged_model.predict(X_test);
y_predicted = str2double(y_predicted); % Convert cell array to numeric array

% Confusion matrix
confusion_matrix = confusionmat(y_test, y_predicted);
figure;
confusionchart(confusion_matrix, {'Cylinder', 'Rubber', 'TPU'});
title('Confusion Matrix for Bagging Model');

% Overall accuracy
accuracy = sum(y_predicted == y_test) / numel(y_test) * 100;
disp(['Overall Accuracy: ', num2str(accuracy), '%']);

