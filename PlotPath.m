function plotPath(lat1, lon1, lat2, lon2, lat_centers, lon_centers, satellite_lat, satellite_lon, closest_satellites)
    figure;

    % Set the map extent
    latlim = [-30 55]; % Latitude range
    lonlim = [-90 45]; % Longitude range
    worldmap(latlim, lonlim);

    %Load and draw the coastline
    load coastlines;
    plotm(coastlat, coastlon);
    
    % Set the latitude and longitude scale display and font size
    setm(gca, 'FontSize', 18, 'FontWeight', 'bold', 'MLabelParallel', 'south');
    setm(gca, 'MLabelLocation', 30, 'PLabelLocation', 20); % Specify the latitude and longitude scale display interval
    %Bold map border
    setm(gca, 'Frame', 'on', 'FLineWidth', 4);
    
    %Plotting satellite positions
    h1 = plotm(satellite_lat, satellite_lon, 'c.', 'MarkerSize', 16, 'MarkerFaceColor', 'c', 'DisplayName', 'All Satellites');

    %Calculate great circle paths
    [latitudes, longitudes] = gcwaypts(lat1, lon1, lat2, lon2, 100);
    h5 = plotm(latitudes, longitudes, 'b-', 'LineWidth', 4, 'DisplayName', 'Great Circle Path');

    % Draw the center point of the path
    h3 = plotm(lat_centers, lon_centers, 'bo', 'MarkerSize', 10, 'MarkerFaceColor', 'b', 'DisplayName', 'Center Points');

    % Plotting the closest satellites
    h4 = plotm(closest_satellites(:,1), closest_satellites(:,2), 'go', 'MarkerSize', 10, 'MarkerFaceColor', 'g', 'DisplayName', 'Closest Satellites');

    % Draw the start and end points
    h2 = plotm(lat1, lon1, 'ro', 'MarkerSize', 10, 'MarkerFaceColor', 'r', 'DisplayName', 'Start/End Points');
    plotm(lat2, lon2, 'ro', 'MarkerSize', 10, 'MarkerFaceColor', 'r'); % Do not set DisplayName

    % Connect all the nearest satellites, with the starting point being the first nearest satellite and the end point being the last nearest satellite
    h6 = plotm(closest_satellites(:,1), closest_satellites(:,2), 'g-', 'LineWidth', 4, 'DisplayName', 'Mapping Path');
    plotm([lat1, closest_satellites(1,1)], [lon1, closest_satellites(1,2)], 'g-', 'LineWidth', 4);
    plotm([lat2, closest_satellites(end,1)], [lon2, closest_satellites(end,2)], 'g-', 'LineWidth', 4);
    % Adjust legend font size
    set(legend, 'FontSize', 18);
    % Add a legend to show only the items you need
    legend([ h1, h2, h3, h4, h5, h6], { 'OneWeb Satellites', 'Start/End Points', 'AGCPM Centers', 'AGCPM Satellites', 'Great Circle Path', 'AGCPM Path'}, 'Location', 'southeast');
   
    % Set DPI and save the image
    set(gcf, 'PaperUnits', 'inches');
    set(gcf, 'PaperPosition', [0 0 8 7]); % Set the image size to 8:7 rectangle
    set(gca, 'LineWidth', 3); % Adjust the width of the coordinate axis
    set(gca, 'Box', 'on');

    % Save the image at 1000 DPI
    %print(gcf, 'C:\Users\18216\Desktop\Paper3\pic\oneweb_path_sigma30.png', '-dpng', '-r800');
end
