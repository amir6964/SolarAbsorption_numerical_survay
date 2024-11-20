% MATLAB numerical survey for measuring the Solar Absorption and Optimal Inclination

% Constants and parameters
latitude = 35.9; % Latitude of location (Karaj, Iran)
solar_constant = 945; % Average solar constant (W/m^2)
hours = 10.5:1:16.5; % Hours of the day (10:30 AM to 4:30 PM)
inclination_angles = 10:10:50; % Inclination angles to test (degrees)
efficiency = 0.33; % Conventional solar still efficiency
absorptivity_glass = 0.85; % Absorptivity of the glass cover

% Day of the year (June 21 -> day 172)
day_of_year = 172;

% Calculate solar declination angle dynamically
declination = 23.45 * sind((360 / 365) * (284 + day_of_year)); % Degrees

% Initialize arrays to store results
radiation_data = zeros(length(inclination_angles), length(hours)); % Solar radiation
absorption_glass = zeros(length(inclination_angles), length(hours)); % Absorption
total_absorption = zeros(1, length(inclination_angles)); % Total absorption

% Loop over inclination angles
for i = 1:length(inclination_angles)
    angle = inclination_angles(i);
    daily_absorption = 0; % Reset for each inclination angle
    
    % Loop over selected hours of the day
    for h = 1:length(hours)
        hour_angle = 15 * (hours(h) - 12); % Hour angle (degrees)
        
        % Calculate solar altitude angle (alpha)
        altitude_angle = asind(sind(latitude) * sind(declination) + ...
            cosd(latitude) * cosd(declination) * cosd(hour_angle));
        
        % Calculate solar radiation on inclined surface
        if altitude_angle > 0
            radiation = solar_constant * (sind(altitude_angle) * cosd(angle) + ...
                cosd(altitude_angle) * sind(angle));
        else
            radiation = 0; % No radiation at negative altitude angles
        end
        
        % Calculate solar absorption by the glass cover
        absorption = absorptivity_glass * radiation;
        absorption_glass(i, h) = absorption; % Store hourly absorption
        daily_absorption = daily_absorption + absorption; % Sum for total absorption
    end
    
    % Store total absorption for the current angle
    total_absorption(i) = daily_absorption;
end

% Find the optimal inclination angle
[~, optimal_index] = max(total_absorption); % Index of maximum absorption
optimal_angle = inclination_angles(optimal_index);

% Display total absorption results
disp('Total Absorption for Each Angle (W/m^2):');
for i = 1:length(inclination_angles)
    fprintf('Angle = %d°, Total Absorption = %.2f W/m^2\n', ...
        inclination_angles(i), total_absorption(i));
end
fprintf('Optimal Inclination Angle: %d°\n', optimal_angle);

disp('Simulation complete.');
