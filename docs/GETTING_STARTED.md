# Getting Started with Remote Sensing MATLAB Simulations

This guide will help you get started with the Remote Sensing MATLAB framework.

## Prerequisites

Before you begin, ensure you have:

1. **MATLAB R2019b or later** installed
2. **Required Toolboxes**:
   - Image Processing Toolbox
   - Statistics and Machine Learning Toolbox
   - (Optional) Computer Vision Toolbox

To check if you have the required toolboxes:
```matlab
ver
```

## Installation

1. **Clone the repository**:
```bash
git clone https://github.com/AliArabi2022/Remote-Sensing.git
cd Remote-Sensing
```

2. **Open MATLAB** and navigate to the repository directory:
```matlab
cd('/path/to/Remote-Sensing')
```

## Quick Start

### Running Your First Example

1. Navigate to the examples directory:
```matlab
cd examples
```

2. Run the test script to validate the installation:
```matlab
test_framework
```

3. Run a complete example:
```matlab
example_multispectral
```

### What You'll See

The example will:
- Generate synthetic multispectral data
- Calculate vegetation indices (NDVI, EVI, SAVI, NDWI)
- Perform image classification
- Analyze crop health
- Display multiple visualization windows

## Basic Workflow

### 1. Data Simulation

```matlab
% Add source directory to path
addpath(genpath('../src'));

% Create multispectral data (200x200 pixels, 6 bands)
data = simulate_multispectral_data(200, 200, 6);

% Visualize
visualize_data(data, 'multispectral');
```

### 2. Analysis

```matlab
% Calculate vegetation indices
indices = calculate_vegetation_indices(data);

% View NDVI
figure;
imagesc(indices.NDVI);
colorbar;
title('NDVI');
```

### 3. Classification

```matlab
% K-means classification (4 classes)
classified = classify_kmeans(data, 4);

% Visualize results
figure;
imagesc(classified);
colormap(parula(4));
colorbar;
title('Classification Map');
```

## Examples Overview

### 1. Multispectral Processing (`example_multispectral.m`)
- Data simulation
- Vegetation index calculation
- Image enhancement
- Unsupervised classification
- Crop health analysis

**Run**: `example_multispectral`

### 2. Hyperspectral Processing (`example_hyperspectral.m`)
- IPS200-compatible hyperspectral simulation
- Spectral signature analysis
- PCA and MNF dimensionality reduction
- Classification on reduced data

**Run**: `example_hyperspectral`

### 3. SAR Processing (`example_radar.m`)
- SAR data simulation (multiple polarizations)
- Speckle filtering (Lee, Frost, Median)
- Multi-polarization analysis
- Land cover classification

**Run**: `example_radar`

### 4. LiDAR Processing (`example_lidar.m`)
- Digital Elevation Model (DEM) simulation
- Terrain feature extraction (slope, aspect, curvature)
- 3D visualization
- Terrain classification

**Run**: `example_lidar`

### 5. Agricultural Applications (`example_agriculture.m`)
- Crop health monitoring
- Yield estimation
- Problem area identification
- Management zone creation
- Precision agriculture recommendations

**Run**: `example_agriculture`

### 6. Environmental Monitoring (`example_environmental.m`)
- Multi-temporal analysis
- Water body detection
- Deforestation monitoring
- Change detection
- Impact assessment

**Run**: `example_environmental`

## Working with Your Own Data

### Loading Data

```matlab
% Load from file
data = load_data('mydata.tif', 'multispectral');

% Or load MATLAB file
load('mydata.mat');
```

### Saving Results

```matlab
% Save classification results
save_data(classified, 'output.mat', 'mat');

% Save as image
imwrite(uint8(classified), 'classification.png');
```

## Common Tasks

### Task 1: Calculate NDVI from Your Data

```matlab
addpath(genpath('../src'));

% Load your data (ensure it has at least 4 bands: B, G, R, NIR)
data = load_data('your_image.tif', 'multispectral');

% Calculate indices
indices = calculate_vegetation_indices(data);

% Display NDVI
figure;
imagesc(indices.NDVI);
colorbar;
colormap jet;
title('NDVI Analysis');
```

### Task 2: Classify a Scene

```matlab
% Load or simulate data
data = simulate_multispectral_data(300, 300, 6);

% Enhance
enhanced = enhance_image(data, 'contrast_stretch');

% Classify
num_classes = 5;
classified = classify_kmeans(enhanced, num_classes);

% Visualize
figure;
imagesc(classified);
colormap(parula(num_classes));
colorbar;
title('Land Cover Classification');
```

### Task 3: Process SAR Data

```matlab
% Simulate or load SAR data
sar_data = simulate_sar_data(200, 200, 'polarization', 'VV');

% Apply speckle filter
filtered = speckle_filter_sar(sar_data.amplitude, 'lee', 5);

% Visualize (in dB)
figure;
subplot(1,2,1);
imagesc(20*log10(sar_data.amplitude + eps));
colormap gray;
title('Original (dB)');
colorbar;

subplot(1,2,2);
imagesc(20*log10(filtered + eps));
colormap gray;
title('Filtered (dB)');
colorbar;
```

### Task 4: Analyze Terrain

```matlab
% Load or simulate LiDAR data
lidar_data = simulate_lidar_data(250, 250, 'terrain_type', 'hilly');

% Extract features
features = extract_lidar_features(lidar_data.elevation);

% Create hillshade visualization
figure;
imagesc(features.hillshade);
colormap gray;
axis image;
title('Hillshade');

% Display slope
figure;
imagesc(features.slope);
colormap hot;
colorbar;
title('Slope (degrees)');
```

## Troubleshooting

### Error: "Undefined function or variable"
- Make sure you've added the src directory to your path: `addpath(genpath('../src'))`
- Check that you're in the correct directory

### Error: "Not enough input arguments"
- Check the function documentation at the top of each .m file
- Ensure you're providing all required parameters

### Error: "Requires Image Processing Toolbox"
- Install the required MATLAB toolbox
- Check installation with `ver`

### Visualizations don't appear
- Make sure figures are not being suppressed
- Try `figure; imagesc(data); colorbar;`

## Next Steps

1. **Explore the examples**: Run all 6 example scripts to see the full capabilities
2. **Read the documentation**: Check `docs/README_DETAILED.md` for function reference
3. **Modify examples**: Experiment with different parameters
4. **Use real data**: Apply the tools to your own datasets
5. **Extend the framework**: Add new algorithms or applications

## Educational Resources

### For Students
- Start with `example_multispectral.m` to understand the basic workflow
- Study the code to learn MATLAB programming techniques
- Experiment with different parameters to see their effects

### For Researchers
- Use the framework as a testbed for new algorithms
- Combine multiple techniques for novel applications
- Extend with your own classification or processing methods

### For Educators
- Use examples as teaching demonstrations
- Assign modifications as homework
- Build custom examples for specific learning objectives

## Getting Help

- Check function documentation: `help function_name`
- Review example scripts for usage patterns
- Read the detailed documentation in `docs/`
- Open an issue on GitHub for bugs or questions

## Contributing

Contributions are welcome! See the main README for contribution guidelines.

---

**Happy Remote Sensing!** 🛰️🌍
