function calculateAccess(root, closest_satellite_names, senderName, receiverName)
    % satellites: Nx2 matrix of satellite names as strings (e.g., ["Satellite1", "Satellite2"; "Satellite2", "Satellite3"; ...])
    % scenario: an active STK scenario object
    % Iterate over each pair of satellites
    numPairs = size(closest_satellite_names, 1);
    root.ExecuteCommand(['Access */Place/', senderName, ' */Satellite/',closest_satellite_names{1}]);
    disp(['Access */Place/', senderName, ' */Satellite/',closest_satellite_names{1}]);
    root.ExecuteCommand(['Access */Place/', receiverName, ' */Satellite/',closest_satellite_names{ numPairs}]);
    disp(['Access */Place/', receiverName, ' */Satellite/',closest_satellite_names{ numPairs}]);
    for i = 1:(numPairs-1)
        sat1 = closest_satellite_names{i};
        sat2 = closest_satellite_names{i+1};   
        disp(['Access */Satellite/',sat1, ' */Satellite/',sat2]);
        root.ExecuteCommand(['Access */Satellite/',sat1, ' */Satellite/',sat2]);     
    end
end
