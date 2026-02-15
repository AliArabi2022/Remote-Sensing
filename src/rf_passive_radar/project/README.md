# GNSS-R Coherence Detection Toolbox

![GNSS-R Concept Illustration](https://img.shields.io/badge/GNSS--R-Coherence%20Detection-blue)  
[![MATLAB](https://img.shields.io/badge/MATLAB-R2018b%2B-orange)](https://www.mathworks.com/products/matlab.html)  

## Introduction

This repository provides a **MATLAB toolbox** for detecting **coherence** in Global Navigation Satellite System Reflectometry (**GNSS-R**) signals. It implements five advanced coherence detection methods:

- **Trailing Edge Slope (TES)**
- **Coherent-to-Incoherent Ratio (CIR)**
- **Entropy-based Metric**
- **Peak Power / SNR with Waveform Shape**
- **Phase Coherence**

These techniques distinguish **coherent** (specular, phase-preserving) reflections from **incoherent** (diffuse, phase-scattered) ones — a key step for applications such as:

- Soil moisture estimation
- Inland water detection
- Sea ice monitoring
- Vegetation analysis

The toolbox includes standalone functions for each method and a main comparison script (`coherence_comparison.m`) that evaluates them on real (e.g. CYGNSS, TDS-1) or simulated GNSS-R data.

All methods are implemented following state-of-the-art research papers to ensure reproducibility and extensibility.

## Installation

1. Clone the repository:

   ```bash
   git clone https://github.com/AliArabi2022/Remote-Sensing.git
   ```
   ```bash
   cd Remote-Sensing/src/rf_passive_radar/project
   ```
   Note: The coherence detection code is located in src/rf_passive_radar/project/.

2. Requirements:
- MATLAB R2018b or later
- Signal Processing Toolbox
- No other toolboxes or external dependencies required — all functions are self-contained.
## Usage

1. Place your GNSS-R data files (NetCDF or .mat) in the data/ folder (create it if needed).
2. Run the main comparison script:
  ```matlab
  coherence_comparison
  ```
This script:
- Loads sample data
- Computes power waveforms (if needed)
- Applies all five methods
- Generates a comparison table with coherence decisions and metric values
3.	Customize thresholds and inputs in each function based on your dataset.
```matlab
% Example: Load I/Q waveform data from NetCDF
filename = 'data/CAR09_0520_WAV_LND10020.nc';
I_wave = ncread(filename, 'I_Waveform');
Q_wave = ncread(filename, 'Q_Waveform');

% Compute power waveform
waveform = abs(I_wave + 1j * Q_wave).^2;

% Example: TES method
[isCoherent, TES_slope] = detectCoherenceTES(waveform);
```
Customize thresholds and parameters inside each function according to your dataset characteristics.
## Methods and Functions
Each method is implemented as a standalone function, with descriptions, parameters, and performance metrics from the original papers.
1. Trailing Edge Slope (TES)
Description: Computes the slope of the trailing edge in the normalized integrated delay waveform to detect coherence. Steep slopes indicate coherent reflections (e.g., smooth surfaces like calm water or wet soil), while gentle slopes suggest incoherence (rough terrain or vegetation). The method fits a linear model to the trailing edge and compares the slope to a threshold.
Function: detectCoherenceTES(waveform)
-	Input: waveform - 1D array of power waveform.
-	Output: isCoherent (boolean), TES (slope value).
-	Threshold: >0.1 (adjustable; based on empirical data for CYGNSS-like waveforms).
-	Metrics from Paper: Detection Probability (PD) = 93.8%, low Probability of Error (PE). From Al-Khaldi et al. [1].
2. Coherent-to-Incoherent Ratio (CIR)
Description: Separates coherent and incoherent components by estimating variance and averaging. CIR = coherent power / incoherent power. High CIR indicates dominant coherence (e.g., specular reflections from wet soil), low CIR suggests incoherence. Useful for untangling mixed signals in ocean or land applications.
Function: detectCoherenceCIR(waveform, Ninc)
-	Input: waveform - 1D complex array (I + jQ), Ninc - number of incoherent averages.
-	Output: isCoherent (boolean), CIR (ratio value).
-	Threshold: >0.5 (from experimental evidences).
-	Metrics from Paper: F1-score ≈0.98 for classification. From Munoz-Martin et al. [2].
3. Entropy-based Metric
Description: Uses Von Neumann entropy on the density matrix of the correlation matrix to measure mixing between coherent and incoherent states. Low entropy indicates high coherence (ordered states, e.g., smooth wet surfaces), high entropy suggests incoherence (mixed states). Applies eigenvalue decomposition for computation.
Function: detectCoherenceEntropy(correlationMatrix)
-	Input: correlationMatrix - covariance matrix of complex waveform.
-	Output: isCoherent (boolean), entropy (value).
-	Threshold: <0.5 (empirical for land applications).
-	Metrics from Paper: ROC AUC ≈0.9, effective for wetlands/open water differentiation. From Russo et al. [3].
4. Peak Power / SNR with Waveform Shape
Description: Combines SNR (peak power / noise) and shape spread (variance / mean) to detect coherence. High SNR and low spread indicate coherent signals (sharp waveforms from moist, flat soil), low SNR/high spread suggests incoherence. Noise is estimated from non-peak regions.
Function: detectCoherenceSNR(waveform)
-	Input: waveform - 1D power array.
-	Output: isCoherent (boolean), SNR (dB value).
-	Threshold: SNR >10 dB and spread <0.5.
-	Metrics from Paper: Accuracy ≈98% for land/ocean classification. Derived from Al-Khaldi et al. [1] and related works.
5. Phase Coherence
Description: Measures phase uniformity using circular statistics (Rayleigh test). Low uniformity (clustered phases) indicates coherence (stable phase from smooth surfaces like wet soil), high uniformity (random phases) suggests incoherence. Useful for change detection in phase data.
Function: detectCoherencePhase(phaseData)
-	Input: phaseData - 1D array of phase values (cycles or radians).
-	Output: isCoherent (boolean), phaseUniformity (score 0-1).
-	Threshold: <0.5 (low uniformity = coherent).
-	Metrics from Paper: Accuracy 98.66% with SVM classification. From Chamseddine et al. [4] and Russo et al. [3].
## Comparison Script
The coherence_comparison.m script loads your GNSS-R data (e.g., from NetCDF), computes power waveforms, selects sample records, applies all methods, and outputs a table comparing coherence detections and article metrics.
## References
-	[1] M. M. Al-Khaldi et al., "An Algorithm for Detecting Coherence in Cyclone Global Navigation Satellite System Mission Level-1 Delay-Doppler Maps," IEEE Transactions on Geoscience and Remote Sensing, vol. 59, no. 3, pp. 2533-2542, 2021. DOI: 10.1109/TGRS.2020.3009784.
-	[2] J. F. Munoz-Martin et al., "Untangling the GNSS-R Coherent and Incoherent Components: Experimental Evidences Over the Ocean," Remote Sensing, vol. 12, no. 7, p. 1208, 2020. DOI: 10.3390/rs12071208.
-	[3] I. M. Russo et al., "Entropy-Based Coherence Metric for Land Applications of GNSS-R," IEEE Transactions on Geoscience and Remote Sensing, vol. 60, pp. 1-13, 2022, Art no. 5613413. DOI: 10.1109/TGRS.2021.3126626.
-	[4] A. Chamseddine et al., "Phase Coherence Change Detection via Circular Uniformity Test Applied to GNSS-Reflectometry," IEEE International Geoscience and Remote Sensing Symposium (IGARSS), 2024. DOI: 10.1109/IGARSS53475.2024.10715090.

