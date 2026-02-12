%% Test Script for Remote Sensing Framework
% This script performs basic validation of the remote sensing framework
% Run this in MATLAB to verify all functions are working

clear; close all; clc;

fprintf('=== Remote Sensing Framework Validation ===\n\n');

% Add all source directories to path
addpath(genpath('../src'));

test_results = struct();
total_tests = 0;
passed_tests = 0;

%% Test 1: Multispectral Data Simulation
fprintf('Test 1: Multispectral data simulation...\n');
try
    data = simulate_multispectral_data(50, 50, 4, 'noise', 0.05);
    assert(all(size(data) == [50, 50, 4]), 'Wrong data dimensions');
    fprintf('  ✓ PASSED\n');
    passed_tests = passed_tests + 1;
catch ME
    fprintf('  ✗ FAILED: %s\n', ME.message);
end
total_tests = total_tests + 1;

%% Test 2: Vegetation Indices
fprintf('Test 2: Vegetation indices calculation...\n');
try
    data = simulate_multispectral_data(50, 50, 6);
    indices = calculate_vegetation_indices(data);
    assert(isfield(indices, 'NDVI'), 'NDVI not calculated');
    assert(isfield(indices, 'EVI'), 'EVI not calculated');
    fprintf('  ✓ PASSED\n');
    passed_tests = passed_tests + 1;
catch ME
    fprintf('  ✗ FAILED: %s\n', ME.message);
end
total_tests = total_tests + 1;

%% Test 3: Hyperspectral Data Simulation
fprintf('Test 3: Hyperspectral data simulation...\n');
try
    data_struct = simulate_hyperspectral_data(40, 40, 100);
    assert(isfield(data_struct, 'image'), 'No image field');
    assert(isfield(data_struct, 'wavelengths'), 'No wavelengths field');
    assert(all(size(data_struct.image) == [40, 40, 100]), 'Wrong dimensions');
    fprintf('  ✓ PASSED\n');
    passed_tests = passed_tests + 1;
catch ME
    fprintf('  ✗ FAILED: %s\n', ME.message);
end
total_tests = total_tests + 1;

%% Test 4: SAR Data Simulation
fprintf('Test 4: SAR data simulation...\n');
try
    data = simulate_sar_data(50, 50, 'polarization', 'VV');
    assert(isfield(data, 'amplitude'), 'No amplitude field');
    assert(isfield(data, 'phase'), 'No phase field');
    fprintf('  ✓ PASSED\n');
    passed_tests = passed_tests + 1;
catch ME
    fprintf('  ✗ FAILED: %s\n', ME.message);
end
total_tests = total_tests + 1;

%% Test 5: LiDAR Data Simulation
fprintf('Test 5: LiDAR data simulation...\n');
try
    data = simulate_lidar_data(50, 50, 'terrain_type', 'hilly');
    assert(isfield(data, 'elevation'), 'No elevation field');
    assert(all(size(data.elevation) == [50, 50]), 'Wrong dimensions');
    fprintf('  ✓ PASSED\n');
    passed_tests = passed_tests + 1;
catch ME
    fprintf('  ✗ FAILED: %s\n', ME.message);
end
total_tests = total_tests + 1;

%% Test 6: Image Enhancement
fprintf('Test 6: Image enhancement...\n');
try
    data = simulate_multispectral_data(50, 50, 4);
    enhanced = enhance_image(data, 'contrast_stretch');
    assert(all(size(enhanced) == size(data)), 'Dimension mismatch');
    fprintf('  ✓ PASSED\n');
    passed_tests = passed_tests + 1;
catch ME
    fprintf('  ✗ FAILED: %s\n', ME.message);
end
total_tests = total_tests + 1;

%% Test 7: K-means Classification
fprintf('Test 7: K-means classification...\n');
try
    data = simulate_multispectral_data(50, 50, 4);
    classified = classify_kmeans(data, 3);
    assert(all(size(classified) == [50, 50]), 'Wrong output dimensions');
    assert(max(classified(:)) <= 3, 'Wrong number of classes');
    fprintf('  ✓ PASSED\n');
    passed_tests = passed_tests + 1;
catch ME
    fprintf('  ✗ FAILED: %s\n', ME.message);
end
total_tests = total_tests + 1;

%% Test 8: PCA
fprintf('Test 8: PCA dimensionality reduction...\n');
try
    data = simulate_multispectral_data(50, 50, 6);
    [reduced, transform] = apply_pca(data, 3);
    assert(all(size(reduced) == [50, 50, 3]), 'Wrong output dimensions');
    assert(isfield(transform, 'explained'), 'No variance explained');
    fprintf('  ✓ PASSED\n');
    passed_tests = passed_tests + 1;
catch ME
    fprintf('  ✗ FAILED: %s\n', ME.message);
end
total_tests = total_tests + 1;

%% Test 9: LiDAR Feature Extraction
fprintf('Test 9: LiDAR feature extraction...\n');
try
    data = simulate_lidar_data(50, 50);
    features = extract_lidar_features(data.elevation);
    assert(isfield(features, 'slope'), 'No slope field');
    assert(isfield(features, 'aspect'), 'No aspect field');
    fprintf('  ✓ PASSED\n');
    passed_tests = passed_tests + 1;
catch ME
    fprintf('  ✗ FAILED: %s\n', ME.message);
end
total_tests = total_tests + 1;

%% Test 10: Speckle Filtering
fprintf('Test 10: SAR speckle filtering...\n');
try
    data = simulate_sar_data(50, 50);
    filtered = speckle_filter_sar(data.amplitude, 'lee', 5);
    assert(all(size(filtered) == size(data.amplitude)), 'Dimension mismatch');
    fprintf('  ✓ PASSED\n');
    passed_tests = passed_tests + 1;
catch ME
    fprintf('  ✗ FAILED: %s\n', ME.message);
end
total_tests = total_tests + 1;

%% Summary
fprintf('\n=== Test Summary ===\n');
fprintf('Tests passed: %d / %d\n', passed_tests, total_tests);
fprintf('Success rate: %.1f%%\n', (passed_tests/total_tests)*100);

if passed_tests == total_tests
    fprintf('\n✓ All tests passed! Framework is ready to use.\n');
else
    fprintf('\n⚠ Some tests failed. Please check the error messages above.\n');
end
