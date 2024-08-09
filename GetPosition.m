%Get the satellite and place positions and make sure the place exists
function ensureAllPlacesExist(root, senderName, senderLat, senderLon, senderAlt, receiverName, receiverLat, receiverLon, receiverAlt)
    % Make sure both the sender and receiver's Place exist and set the location
    ensurePlaceExists(root, senderName, senderLat, senderLon, senderAlt);
    ensurePlaceExists(root, receiverName, receiverLat, receiverLon, receiverAlt);
end

function ensurePlaceExists(root, placeName, lat, lon, alt)
    % Check if the Place already exists
    try
        root.GetObjectFromPath(['Place/' placeName]);
        placeExists = true;
    catch
        placeExists = false;
    end
    % If the Place does not exist, create a new one.
    if ~placeExists
        root.ExecuteCommand(['New / */Place ' placeName]);
    end
    
    % Set the location of the Place
    root.ExecuteCommand(['SetPosition */Place/' placeName ' Geodetic ' num2str(lat) ' ' num2str(lon) ' ' num2str(alt)]);
end

function satPosition = getSatellitePosition(satelliteName, current_time)
    % Get the latitude, longitude and altitude of a satellite or ground station
    uiApplication = actxGetRunningServer('STK11.Application');
    root = uiApplication.Personality2;
    scenario = root.CurrentScenario;
    command = sprintf('Position */Satellite/%s %s', satelliteName, current_time);
    result = root.ExecuteCommand(command);
    XYZ = strsplit(result.Item(0));
    if length(XYZ) >= 3
        satPosition = [str2double(XYZ{7}), str2double(XYZ{8}), str2double(XYZ{9})];
    else
        error('Failed to get position for %s', satelliteName);
    end

end

function placePosition = getPlacePosition(placeName, current_time)
    % Get the latitude, longitude and altitude of a satellite or ground station
    uiApplication = actxGetRunningServer('STK11.Application');
    root = uiApplication.Personality2;
    scenario = root.CurrentScenario;
    command = sprintf('Position */Place/%s %s', placeName, current_time);
    result = root.ExecuteCommand(command);
    XYZ = strsplit(result.Item(0));

    if length(XYZ) >= 3
        placePosition = [str2double(XYZ{7}), str2double(XYZ{8}), str2double(XYZ{9})];
    else
        error('Failed to get position for %s', placeName);
    end
    
end
