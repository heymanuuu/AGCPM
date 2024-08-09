%Link Dynamic Switching
function runAnalysis(senderName, senderLat, senderLon, senderAlt, receiverName, receiverLat, receiverLon, receiverAlt, startTime, repetitions, root)
    % Make sure the location exists
    ensureAllPlacesExist(root, senderName, senderLat, senderLon, senderAlt, receiverName, receiverLat, receiverLon, receiverAlt);

    current_time = startTime; % Initial time

    for rep = 1:repetitions
        % Format the current time into the required format
        formatted_time = formatTime(datetime(current_time, 'InputFormat', 'dd MMM yyyy HH:mm:ss', 'Locale', 'en_US'));

        fprintf('Current time：%s\n', formatted_time);
        
        % Plan a path and get the center point
        [lat_centers, lon_centers] = planPath(senderLat, senderLon, receiverLat, receiverLon);
        disp('The center point of each path [latitude, longitude]：');
        disp([lat_centers', lon_centers']);

        % Get the latitude and longitude of all satellites
        [satellite_lat, satellite_lon, satellite_names] = getAllSatellites(root, formatted_time);

        % Find the closest satellite to each center point
        [closest_satellites, distances, closest_satellite_names] = findClosestSatellites(lat_centers, lon_centers, satellite_lat, satellite_lon, satellite_names);

        %Display results
        for i = 1:length(lat_centers)
            fprintf('From the center [%f, %f] the nearest satellite at this moment is: %s [%f, %f]\n', ...
                lat_centers(i), lon_centers(i), closest_satellite_names{i}, ...
                closest_satellites(i, 1), closest_satellites(i, 2)); 
        end

        % Display the nearest satellite name
        for i = 1:length(lat_centers)
            fprintf('%s\n' , closest_satellite_names{i});
        end

        %Draw paths and center points
        plotPath(senderLat, senderLon, receiverLat, receiverLon, lat_centers, lon_centers, satellite_lat, satellite_lon, closest_satellites);

        % Calculating Delay
        delays = calculateDelays(closest_satellite_names, senderName, receiverName, formatted_time);
        delays_len = length(delays);
        totalDelay = sum(delays);
        
        % Add one minute
        dt = datetime(current_time, 'InputFormat', 'dd MMM yyyy HH:mm:ss', 'Locale', 'en_US');
        dt = dt + minutes(1);
        current_time = datestr(dt, 'dd mmm yyyy HH:MM:SS');
    end
end

function formatted_time = formatTime(dt)
    %Formatting date and time components
    dateTimeStr = datestr(dt, 'dd mmm yyyy HH:MM:SS');
    % Add milliseconds part and leading space
    formatted_time = [' " ' dateTimeStr '.000"'];
end
