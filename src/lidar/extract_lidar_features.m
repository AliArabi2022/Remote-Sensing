function features = extract_lidar_features(elevation_data)
% EXTRACT_LIDAR_FEATURES Extract terrain features from LiDAR elevation data
%
% Syntax:
%   features = extract_lidar_features(elevation_data)
%
% Input:
%   elevation_data - Digital Elevation Model (rows x cols)
%
% Output:
%   features - Structure with slope, aspect, roughness, curvature
%
% Description:
%   Extracts topographic features from LiDAR elevation data

    [rows, cols] = size(elevation_data);
    
    % Calculate gradients
    [Gx, Gy] = gradient(elevation_data);
    
    % Slope (in degrees)
    slope_rad = atan(sqrt(Gx.^2 + Gy.^2));
    features.slope = rad2deg(slope_rad);
    
    % Aspect (direction of slope)
    features.aspect = atan2(Gy, Gx);
    features.aspect = mod(features.aspect * 180/pi, 360);
    
    % Roughness (standard deviation in local window)
    window_size = 5;
    features.roughness = stdfilt(elevation_data, ones(window_size));
    
    % Curvature (second derivatives)
    [Gxx, Gxy] = gradient(Gx);
    [~, Gyy] = gradient(Gy);
    features.curvature = Gxx + Gyy;
    
    % Profile curvature
    features.profile_curvature = -(Gxx.*Gx.^2 + 2*Gxy.*Gx.*Gy + Gyy.*Gy.^2) ./ ...
                                  ((Gx.^2 + Gy.^2 + eps).^1.5);
    
    % Plan curvature
    features.plan_curvature = -(Gxx.*Gy.^2 - 2*Gxy.*Gx.*Gy + Gyy.*Gx.^2) ./ ...
                               ((Gx.^2 + Gy.^2 + eps).^1.5);
    
    % Hillshade (for visualization)
    azimuth = 315 * pi/180;
    altitude = 45 * pi/180;
    features.hillshade = sin(altitude) .* sin(slope_rad) + ...
                        cos(altitude) .* cos(slope_rad) .* ...
                        cos(azimuth - features.aspect*pi/180);
    
    fprintf('LiDAR features extracted: slope, aspect, roughness, curvature\n');
end
