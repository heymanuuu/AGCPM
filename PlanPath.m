% Planning path
function [lat_centers, lon_centers] = planPath(lat1, lon1, lat2, lon2)
   % Input: latitude and longitude of the starting and ending points
   % Output: latitude and longitude of the center point of each path

    % Calculate points of great circle path
    num_points = 100; % Points on the great circle
    [latitudes, longitudes] = gcwaypts(lat1, lon1, lat2, lon2, num_points);
    
    % Calculate the Euclidean distance between longitude and latitude
    euclidean_distance = sqrt((lat2 - lat1)^2 + (lon2 - lon1)^2);

    % Calculate the number of segments
    segment_length = 30; %
    num_segments = ceil(euclidean_distance / segment_length);

    % Pre-assigned center point
    lat_centers = zeros(1, num_segments);
    lon_centers = zeros(1, num_segments);

    % Calculate the center point of each segment
    segment_length = floor(length(latitudes) / num_segments);
    for i = 1:num_segments
        start_idx = (i - 1) * segment_length + 1;
        end_idx = min(i * segment_length, length(latitudes));
        lat_centers(i) = mean(latitudes(start_idx:end_idx));
        lon_centers(i) = mean(longitudes(start_idx:end_idx));
    end
end
