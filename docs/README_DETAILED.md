# Remote Sensing MATLAB Simulations

A comprehensive MATLAB-based framework for remote sensing data processing, analysis, and visualization. This repository extends beyond hyperspectral data (like IPS200) to include multispectral, radar (SAR), and LiDAR techniques, serving as an educational and research tool.

## Features

### Data Types Supported
- **Multispectral**: 4-12 bands (Blue, Green, Red, NIR, SWIR)
- **Hyperspectral**: 100-200+ bands (IPS200 compatible, 400-2500 nm)
- **Radar (SAR)**: Multi-polarization (VV, HH, VH, HV)
- **LiDAR**: Digital Elevation Models (DEM) and point clouds

### Core Capabilities
1. **Data Acquisition & Simulation**: Generate synthetic remote sensing data for testing and education
2. **Image Enhancement**: Histogram equalization, contrast stretching, filtering
3. **Classification**: K-means, SVM, KNN, decision trees
4. **Dimensionality Reduction**: PCA, MNF
5. **Vegetation Indices**: NDVI, EVI, SAVI, NDWI
6. **Terrain Analysis**: Slope, aspect, curvature, hillshade
7. **Change Detection**: Multi-temporal analysis

### Applications
- **Agriculture**: Crop health monitoring, yield estimation, precision farming
- **Environmental Monitoring**: Deforestation detection, water body mapping, land cover change

## Repository Structure

```
Remote-Sensing/
├── src/                          # Source code (modular organization)
│   ├── utils/                    # Utility functions (load, save, visualize)
│   ├── multispectral/           # Multispectral processing
│   ├── hyperspectral/           # Hyperspectral processing (IPS200 support)
│   ├── radar/                   # SAR data processing
│   ├── lidar/                   # LiDAR processing
│   ├── enhancement/             # Image enhancement algorithms
│   ├── classification/          # Classification methods
│   ├── dimensionality_reduction/ # PCA, MNF, etc.
│   └── applications/            # Real-world applications
│       ├── agriculture/         # Agricultural applications
│       └── environmental/       # Environmental monitoring
├── examples/                    # Complete workflow examples
│   ├── example_multispectral.m
│   ├── example_hyperspectral.m
│   ├── example_radar.m
│   ├── example_lidar.m
│   ├── example_agriculture.m
│   └── example_environmental.m
├── data/                        # Data directory (place datasets here)
└── docs/                        # Documentation
```

## Getting Started

### Prerequisites
- MATLAB R2019b or later
- Image Processing Toolbox
- Statistics and Machine Learning Toolbox
- (Optional) Computer Vision Toolbox

### Quick Start

1. Clone the repository:
```bash
git clone https://github.com/AliArabi2022/Remote-Sensing.git
cd Remote-Sensing
```

2. Run example scripts:
```matlab
cd examples
example_multispectral    % Multispectral data processing
example_hyperspectral    % Hyperspectral (IPS200) processing
example_radar            % SAR data processing
example_lidar            % LiDAR processing
example_agriculture      % Agricultural applications
example_environmental    % Environmental monitoring
```

## Usage Examples

### Multispectral Processing
```matlab
% Simulate multispectral data
data = simulate_multispectral_data(200, 200, 6, 'noise', 0.05);

% Calculate vegetation indices
indices = calculate_vegetation_indices(data);

% Classify
classified = classify_kmeans(data, 4);
```

### Hyperspectral Processing (IPS200)
```matlab
% Simulate hyperspectral data
data_struct = simulate_hyperspectral_data(150, 150, 200, ...
    'wavelengths', linspace(400, 2500, 200));

% Apply PCA
[reduced, transform] = apply_pca(data_struct.image, 10);

% Classify reduced data
classified = classify_kmeans(reduced, 5);
```

### SAR Processing
```matlab
% Simulate SAR data
data = simulate_sar_data(200, 200, 'polarization', 'VV');

% Apply speckle filter
filtered = speckle_filter_sar(data.amplitude, 'lee', 5);
```

### LiDAR Processing
```matlab
% Simulate LiDAR data
data = simulate_lidar_data(250, 250, 'terrain_type', 'hilly');

% Extract terrain features
features = extract_lidar_features(data.elevation);
```

### Agricultural Application
```matlab
% Load multispectral data
data = simulate_multispectral_data(300, 300, 6);

% Analyze crop health
health_results = analyze_crop_health(data);

% Estimate yield
yield_results = estimate_yield(data, 50);  % 50 hectares
```

### Environmental Monitoring
```matlab
% Load time series data
image_t1 = simulate_multispectral_data(250, 250, 6);
image_t2 = simulate_multispectral_data(250, 250, 6);

% Detect deforestation
deforest_results = monitor_deforestation(image_t1, image_t2);

% Detect water bodies
water_results = detect_water_bodies(image_t1);
```

## Function Reference

### Core Utilities (`src/utils/`)
- `load_data(filename, data_type)` - Load remote sensing data
- `save_data(data, filename, format)` - Save data to file
- `visualize_data(data, data_type)` - Visualize data

### Multispectral (`src/multispectral/`)
- `simulate_multispectral_data(rows, cols, bands)` - Generate synthetic data
- `calculate_vegetation_indices(data)` - Compute NDVI, EVI, SAVI, NDWI

### Hyperspectral (`src/hyperspectral/`)
- `simulate_hyperspectral_data(rows, cols, bands)` - IPS200 compatible simulation
- `apply_pca_hyperspectral(data, num_components)` - PCA for hyperspectral data

### Radar (`src/radar/`)
- `simulate_sar_data(rows, cols)` - Generate SAR data
- `speckle_filter_sar(amplitude, filter_type)` - Apply speckle filtering

### LiDAR (`src/lidar/`)
- `simulate_lidar_data(rows, cols)` - Generate LiDAR DEM
- `extract_lidar_features(elevation)` - Extract slope, aspect, curvature

### Enhancement (`src/enhancement/`)
- `enhance_image(data, method)` - Apply image enhancement

### Classification (`src/classification/`)
- `classify_kmeans(data, num_classes)` - K-means clustering
- `classify_supervised(data, training_data, labels, method)` - Supervised classification

### Dimensionality Reduction (`src/dimensionality_reduction/`)
- `apply_pca(data, num_components)` - Principal Component Analysis
- `apply_mnf(data, num_components)` - Minimum Noise Fraction

### Applications - Agriculture (`src/applications/agriculture/`)
- `analyze_crop_health(data)` - Crop health assessment
- `estimate_yield(data, area)` - Yield estimation

### Applications - Environmental (`src/applications/environmental/`)
- `detect_water_bodies(data)` - Water body detection
- `monitor_deforestation(before, after)` - Deforestation monitoring

## Educational Use

This repository is designed for:
- **Students**: Learn remote sensing concepts through hands-on MATLAB coding
- **Researchers**: Prototype and test remote sensing algorithms
- **Educators**: Teaching material for remote sensing courses
- **Practitioners**: Quick prototyping of processing workflows

## Research Applications

Suitable for research in:
- Precision agriculture
- Environmental monitoring
- Land cover classification
- Change detection
- Disaster assessment
- Urban planning

## Contributing

Contributions are welcome! Please feel free to submit pull requests or open issues for:
- New algorithms
- Bug fixes
- Documentation improvements
- Additional examples
- Real dataset loaders

## License

This project is provided for educational and research purposes.

## Citation

If you use this code in your research, please cite:
```
@software{remote_sensing_matlab,
  title={Remote Sensing MATLAB Simulations},
  author={AliArabi2022},
  year={2026},
  url={https://github.com/AliArabi2022/Remote-Sensing}
}
```

## Acknowledgments

- Inspired by real-world remote sensing datasets including IPS200
- Built using MATLAB's Image Processing and Machine Learning toolboxes
- Designed for educational and research advancement in remote sensing

## Contact

For questions or collaborations, please open an issue on GitHub.

---

**Note**: This repository provides simulated data for educational purposes. For real-world applications, please use actual remote sensing datasets and validate results appropriately.
