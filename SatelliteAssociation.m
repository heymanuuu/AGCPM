% Satellite Association
function [closest_satellites, distances, closest_satellite_names] = findClosestSatellites(lat_centers, lon_centers, satellite_lat, satellite_lon, satellite_names)
    num_centers = length(lat_centers);
    num_sats = length(satellite_lat);
    
    closest_satellites = NaN(num_centers, 2);
    distances = NaN(1, num_centers);
    closest_satellite_names = cell(num_centers, 1); % Record the name of the nearest satellite
    used_sats = false(num_sats, 1); % Record whether the satellite is in use

    for i = 1:num_centers
        min_distance = Inf;
        closest_sat = NaN;
        closest_idx = NaN;
        
        for j = 1:num_sats
            if ~used_sats(j)
                dist = haversine(lat_centers(i), lon_centers(i), satellite_lat(j), satellite_lon(j));
                if dist < min_distance
                    min_distance = dist;
                    closest_sat = [satellite_lat(j), satellite_lon(j)];
                    closest_idx = j; % Record the current closest satellite index
                end
            end
        end
        
        if ~isnan(closest_idx) % Ensure that the nearest valid satellite is found
            closest_satellites(i, :) = closest_sat;
            distances(i) = min_distance;
            closest_satellite_names{i} = satellite_names{closest_idx}; % Record satellite name
            used_sats(closest_idx) = true; % Mark as used
        end
    end
end
