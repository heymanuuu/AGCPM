% Function: Get the longitude and latitude of all satellites
function [satellite_lat, satellite_lon, satellite_names] = getAllSatellites(root, current_time)
    %Get the paths of all satellites
    result = root.ExecuteCommand('ShowNames * Class Satellite');
    satellite_paths = strsplit(result.Item(0), ' '); 
    %disp(result.Item(0)); 
    
    % Open a text file for writing
   % fileID = fopen('D:\STK_WORK\satPath.txt', 'w');
    % Write results to a text file
    %fprintf(fileID, '%s\n', result.Item(0));
    % Close File
    %fclose(fileID);

    %Extract satellite names
    satellite_names = cell(size(satellite_paths));
    for i = 1:length(satellite_paths)
        tokens = regexp(satellite_paths{i}, '/Scenario/[^/]+/Satellite/([^/]+)', 'tokens');
        if ~isempty(tokens)
            satellite_names{i} = tokens{1}{1};
            %disp(satellite_names{i});
        end
    end

    % Filter out null values ​​and remove duplicates
    satellite_names = satellite_names(~cellfun('isempty', satellite_names));
    satellite_names = unique(satellite_names);
    
    %Get the longitude and latitude of each satellite
    
    num_sats = length(satellite_names);
    satellite_lat = zeros(num_sats, 1);
    satellite_lon = zeros(num_sats, 1);

    for i = 1:num_sats
    command = sprintf('Position */Satellite/%s %s', satellite_names{i}, current_time);
    result = root.ExecuteCommand(command);
    disp(command);
    % Extract longitude and latitude
    lat_lon = strsplit(result.Item(0));
    if length(lat_lon) >= 2
        satellite_lat(i) = str2double(lat_lon{1});
        satellite_lon(i) = str2double(lat_lon{2});
    end
end
end
