%calculate delays
function delays = calculateDelays(closest_satellite_names, senderName, receiverName, current_time)
    % input
    % closest_satellite_names
    % senderName
    % receiverName
    % current_time
    % output:
    % delays: A list of delay times, each element is the delay time (in seconds) from senderName to one of the nearest satellites.


    % Get the sender and receiver's location
    senderPos = getPlacePosition(senderName, current_time);
    receiverPos = getPlacePosition(receiverName, current_time);

    % Speed ​​of light (km/s)
    c = 299792.458;

    % Initialize delay time list
    delays = zeros(length(closest_satellite_names) + 1, 1);
    satellitePos1 = getSatellitePosition(closest_satellite_names{1}, current_time);
    distance = euclideanDistance(senderPos, satellitePos1);
    delays(length(closest_satellite_names)) = distance / c;
    
    satellitePos2 = getSatellitePosition(closest_satellite_names{length(closest_satellite_names)}, current_time);
    distance = euclideanDistance(receiverPos, satellitePos2);
    delays(length(closest_satellite_names) + 1) = distance / c;
    
    for i = 1:(length(closest_satellite_names)-1)
        satellitePos1 = getSatellitePosition(closest_satellite_names{i}, current_time);
        satellitePos2 = getSatellitePosition(closest_satellite_names{i+1}, current_time);
        distance = euclideanDistance(satellitePos1, satellitePos2);
        %fprintf('%f\n', distance);
        delays(i) = distance / c;
    end
    
end


function d = euclideanDistance(pos1, pos2)
    % input:
    % pos1: XYZ coordinates of the first position (1x3 array)
    % pos2: XYZ coordinates of the second position (1x3 array)
    % output:
    % d: Euclidean distance between two locations (km)

    % Calculate Euclidean distance
    d = sqrt((pos1(1) - pos2(1))^2 + (pos1(2) - pos2(2))^2 + (pos1(3) - pos2(3))^2);
end
