# Remote Sensing Simulations & Processing Toolbox

[![MATLAB](https://img.shields.io/badge/MATLAB-R2020a%2B-blue?logo=matlab&logoColor=white)](https://www.mathworks.com/products/matlab.html)
[![GitHub](https://img.shields.io/badge/GitHub-Remote%20Sensing%20Toolbox-black?logo=github)](https://github.com/)
![Last Updated](https://img.shields.io/badge/Last%20Updated-February%202026-orange)

<p align="center">
  <img src="https://img.shields.io/badge/Hyperspectral-Processing-green" alt="Hyperspectral">
  <img src="https://img.shields.io/badge/GNSS--R-Coherence%20Detection-blue" alt="GNSS-R">
  <img src="https://img.shields.io/badge/6G--JCAS-Research-purple" alt="6G JCAS">
</p>

## Overview
This repository is a comprehensive, open-source collection of MATLAB scripts and tools for remote sensing education, research, and experimentation. It covers the full pipeline from raw data loading and preprocessing to advanced signal processing, image analysis, classification, and emerging applications in GNSS-Reflectometry (GNSS-R) and future 6G-based sensing.
The project started as university course exercises (hyperspectral image processing on Indian Pines dataset) and gradually evolved into a structured toolbox covering:

Classical optical & hyperspectral remote sensing
RF & microwave passive sensing (GNSS-R)
Coherence detection & soil moisture proxy estimation
Future-oriented simulations (OFDM-based 6G sensing)

All codes are modular, well-commented, and organized by sensing domain to make extension and learning easy.

## What Has Been Implemented (From Beginning to Current State)

### 1. Hyperspectral & Optical Remote Sensing (Early Stage – Course Exercises)

- Loading & visualization of classic datasets (Indian Pines – IPS200.mat)
- Band selection & visualization (`band_visualization.m`)
- Spectral signature extraction & plotting (`spectral_signature.m`)
- Histogram & statistical analysis per band (`histogram_and_stats.m`)
- Ground truth map display (`gtm_display.m`)
- Noise addition (Gaussian, salt & pepper, speckle, Poisson) (`add_noise.m`)
- Spatial & frequency domain filtering (`spatial_filters.m`, `frequency_filters.m`)
- Edge detection (Sobel, Canny, etc.) (`edge_detection.m`)
- Histogram equalization & matching (`histogram_matching.m`)
- RGB ↔ HSI color space conversion (`rgb_to_hsi.m`)
- Dimensionality reduction & visualization:
  - PCA-based false color (`pca_false_color.m`)
  - LDA-based false color (`lda_false_color.m`)
  - 2D/3D feature space plotting (`feature_plotting.m`)


- Classification with dimensionality reduction (PCA/LDA + ML/SVM/KNN) (`classification_with_reduction.m`)
- Accuracy vs. number of features curves (`accuracy_curves.m`)
- Vegetation indices & crop health proxy (`example_application.m`)
- Soil moisture proxy via spectral indices (NDWI, NDMI, MSI) (`example_soil_moisture.m`)

### 2. GNSS-Reflectometry (GNSS-R) Processing (Mid Stage)
- Loading & parsing CAROLS 2009 GOLD-RTR NetCDF files (e.g. `CAR09_0520_WAV_LND10020.nc`)
- Time conversion: GPS week + second + ms → UTC datetime
- Separation of direct & reflected waveforms using `Link` (1=direct, 2/3=reflected LHCP/RHCP)۳=بازتاب LHCP/RHCP)
- Power waveform computation (I² + Q²)
- Peak-based reflectivity estimation with basic noise floor correction
- Simple soil moisture proxy via Fresnel approximation & dielectric constant → volumetric moisture
- Coherence detection toolbox with 5 state-of-the-art methods:
  1. **Trailing Edge Slope (TES)** – Al-Khaldi et al. (2021) – PD ≈93.8%
  2. **Coherent-to-Incoherent Ratio (CIR)** – Munoz-Martin et al. (2020) – F1 ≈0.98
  3. **Entropy-based** – Russo et al. (2022) – ROC AUC ≈0.9
  4. **Peak Power / SNR + Shape** – Accuracy ≈98%
  5. **Phase Coherence** – Chamseddine et al. (2024) – Accuracy 98.66%

- Comparison script that applies all 5 methods on real data and shows table + metrics
Five independent detection functions with article-reported metrics:

| Method                        | Core Metric                  | Performance (from paper)       | Reference                                                                 |
|-------------------------------|------------------------------|--------------------------------|---------------------------------------------------------------------------|
| Trailing Edge Slope (TES)     | Slope of normalized trailing edge | PD = 93.8%, low PE             | Al-Khaldi et al. (2021) [TGRS]                                            |
| Coherent-to-Incoherent Ratio  | CIR = coherent / incoherent  | F1-score ≈ 0.98                | Munoz-Martin et al. (2020) [Remote Sensing]                               |
| Von Neumann Entropy           | Entropy of density matrix    | ROC AUC ≈ 0.9                  | Russo et al. (2022) [TGRS]                                                |
| Peak Power / SNR + Shape      | SNR + normalized variance    | Accuracy ≈ 98%                 | Derived from Al-Khaldi & related works                                    |
| Phase Coherence               | Circular phase uniformity    | Accuracy 98.66% (SVM)          | Chamseddine et al. (2024) [IGARSS]                                        |

- Main comparison script (`coherence_comparison_real_data.m`) loads real data, applies all methods, and generates a results table.

### 3. Current Structure of the Repository
remote-sensing-toolbox/
- ├── README.md
- ├── data/                       # datasets (Indian Pines, CAROLS NetCDF, etc.)
- ├── src/
- │   ├── fundamentals/           # basic hyperspectral tools
- │   ├── sensors_acquisition/    # loading, noise, cropping
- │   ├── image_processing/       # filters, enhancement, HSI
- │   ├── dimensionality_reduction/
- │   ├── classification_analysis/
- │   ├── applications/           # vegetation, soil moisture examples
- │   └── rf_gnssr/               # GNSS-R loading, waveform separation, coherence detection
- │       ├── coherence_detection_functions/
- │       └── coherence_comparison_real_data.m
- └── docs/                       # References, articles, notes


## 🛠️ Future Work (Roadmap)

- **OFDM-based 6G Joint Communication & Sensing (JCAS) Simulations**
  - OFDM waveform generation (5G NR / 6G candidate)
  - Bistatic passive radar modeling (transmitter → surface → receiver)
  - Delay-Doppler map (DDM) generation in mmWave/THz bands
  - Soil moisture, vegetation, and urban sensing performance evaluation

- **SAR & InSAR Processing**
  - Sentinel-1 GRD/SLC preprocessing
  - Interferometric coherence & phase analysis
  - Change detection and deformation monitoring

- **Deep Learning Integration**
  - CNN/LSTM for coherence classification
  - Autoencoders for hyperspectral dimensionality reduction
  - U-Net-style semantic segmentation for land cover

- **Advanced GNSS-R**
  - Full DDM generation from raw IF data
  - Multi-constellation support (GPS + Galileo + BeiDou)
  - Altimetry, wind speed, and flood mapping retrieval

- **User Interface**
  - MATLAB App Designer GUI for interactive analysis
  - Live Script tutorials and Jupyter notebook conversions

## 📚 References & Inspirations
- Hyperspectral processing: Purdue AVIRIS Indian Pines dataset & MATLAB Image Processing Toolbox examples
- GNSS-R data & methodology: GOLD-RTR / CAROLS campaigns (ICE-CSIC/IEEC), CYGNSS mission (NASA)
- Coherence detection:
  - Al-Khaldi et al. (2021). IEEE TGRS. DOI: 10.1109/TGRS.2020.3009784
  - Munoz-Martin et al. (2020). Remote Sensing. DOI: 10.3390/rs12071208
  - Russo et al. (2022). IEEE TGRS. DOI: 10.1109/TGRS.2021.3126626
  - Chamseddine et al. (2024). IGARSS. DOI: 10.1109/IGARSS53475.2024.10715090
- 6G JCAS concepts: IEEE Communications Magazine & JSAC special issues on Integrated Sensing & Communication

Last updated: February 2026

🚀 Happy remote sensing!