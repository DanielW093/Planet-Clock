function planetClock()

%All code written by me, adapted from the official MATLAB documentation
%Unless explicitly stated otherwise
%Textures from http://pics-about-space.com/

%Setup stuff
font = 'Bauhaus 93'; %Universal font variable
global KEY_IS_PRESSED %Global variable, is key pressed?
KEY_IS_PRESSED = 0; %Key not pressed
%Set up figure
figure('Name', 'Planetary Clock','Color', 'k', 'NumberTitle', 'off');
%Maximise figure, set renderer, assign keypress function
set(gcf, 'Position', get(0,'Screensize'),'Renderer', 'OpenGL',...
    'KeyPressFcn', @keyPress);
%Change figure title and label
title('Press any key to stop time.', 'Color', 'w','FontName' ...
        , font,'FontSize', 22);

%Clock Values
CR = 16; %Clock Radius
clockPoints = 60; %Amount of points on clock
outer = CR-1; %Outer planet
p1rotSpeed = 1; %Rotate speed of 1st planet
p2rotSpeed = 5; %Rotate speed of 2nd planet
p3rotSpeed = 10; %Rotate speed of 3rd planet
p1r = 0; %Rotation of 1st planet
p2r = 0; %Rotation of 2nd planet
p3r = 0; %Rotation of 3rd planet
mr = 0; %Rotation of moon
p1rad = 0.3; %Planet 1 radius
p2rad = 0.4; %Planet 2 radius
p3rad = 0.6; %Planet 3 radius
moonRad = 0.1; %Moon radius
ambVal = 0.3; %Planet ambient light strength
difVal = 1.0; %Planet diffuse strength
p1spec = 0.0; %Planet 1 specular strength
p2spec = 0.2; %Planet 2 specular strength
p3spec = 0.4; %Planet 3 specular strength
p1orbDist = outer/3; %Planet 1 orbit distance
p2orbDist = (outer/3)*2; %Planet 2 orbit distance
p3orbDist = outer; %Planet 3 orbit distance

%Load Textures
sunTex = imread('sunmap.jpg');
hourTex = imread('planetmap1.jpg'); 
minTex = imread('planetmap2.jpg'); 
secTex = imread('planetmap3.jpg'); 
moonTex = imread('moon.jpg'); 

%Draw clock reference 
drawReference(CR, clockPoints, p1orbDist, p2orbDist, p3orbDist,...
    p1rad, p2rad, p3rad);

hold on %hold

%Start Drawing System
[x,y,z] = sphere(50); %Calculate default sphere

%Create sun object
sun = surface(x,y,z);
%Set colour data and lighting values (sun requires full ambient strength
%for emissive quality)
set(sun,'CData',sunTex,'FaceColor','texturemap','EdgeColor','none','AmbientStrength', 1);

%Text objects to display time and date
timetext = text(-3, -11.75, '00:00:00','HorizontalAlignment','center','FontName',...
    font,'FontSize', 22, 'Color', 'w');
datetext = text(3, -11.75, '00|00|00','HorizontalAlignment','center','FontName',...
    font,'FontSize', 22, 'Color', 'w');

%Set up viewport
axis ([-CR CR -CR CR -1 1 ]) %Set axes
daspect([1 1 1]); %Set aspect ratio
axis off %Turn off axes
view(0,30); %Set view direction

%Lighting
light('Position', [0,0,0], 'style', 'local'); %Create sun light
lighting gouraud; %Set lighting type

%Draw Time while no key has been pressed and while figure exists
while ~KEY_IS_PRESSED && ~isempty(findall(0,'Type','Figure')) 
    %Get system time into vector c
    c = clock;
    hours = c(4); minutes = c(5); seconds = c(6);
    day = c(3); month = c(2); year = mod(c(1),100);
    
    %Set up time strings and pad with necessary zeros
    if hours < 10
        hString = strcat('0',  num2str(hours));
    else
        hString =  num2str(hours);
    end   
    if minutes < 10
        mString = strcat('0',  num2str(minutes));
    else
        mString = num2str(minutes);
    end    
    if seconds < 10
        sString = strcat('0',  num2str(fix(seconds)));
    else
        sString = num2str(fix(seconds));
    end
    %Update time string
    timetext.String = strcat(hString, ':', mString, ':', sString);
    
    %Set up date strings and pad with necessary zeros
    if day < 10
        dString = strcat('0', num2str(day));
    else
        dString = num2str(day);
    end
    if month < 10
        mString = strcat('0', num2str(month));
    else
        mString = num2str(month);
    end
    if(year < 10)
        yString = strcat('0', num2str(year));
    else
        yString = num2str(year);
    end
    %Update date string
    datetext.String = strcat(dString, '/', mString, '/', yString);
    
    %Calculate exact amount of hours and minutes passed
    hoursPassed = hours + (minutes/60) + (seconds/3600); %Hours passed since day started
    minutesPassed = minutes + (seconds/60); %Minutes passed since hour started (round minutes to integers)
    
    %Calculate angle of hands
    hourAngle = 90 - hoursPassed*(360/12); %360 degrees in a circle, 12 hours.
    minuteAngle = 90 - minutesPassed*(360/60); %360 degrees in a circle, 60 minutes.
    secondAngle = 90 - seconds*(360/60); %360 degrees in a circle, 60 seconds.
    
    %Calculate and draw hour planet
    [hourX, hourY] = polar2cart(p1orbDist, hourAngle); %Convert angle to x,y points
    hourPlanet = surface((x*p1rad)+hourX, (y*p1rad)+hourY, z*p1rad);
    %Set colour data and lighting values
    set(hourPlanet,'CData',hourTex,'FaceColor','texturemap','EdgeColor','none',...
        'DiffuseStrength', difVal, 'SpecularStrength', p1spec, 'AmbientStrength', ambVal);

    %Calculate and draw minute planet
    [minX, minY] = polar2cart(p2orbDist, minuteAngle);
    minPlanet = surface((x*p2rad)+minX, (y*p2rad)+minY, z*p2rad);
    %Set colour data and lighting values
    set(minPlanet,'CData',minTex,'FaceColor','texturemap','EdgeColor','none',...
        'DiffuseStrength', difVal, 'SpecularStrength', p2spec, 'AmbientStrength', ambVal);
    
     %Calculate and draw second planet
    [secX, secY] = polar2cart(p3orbDist, secondAngle);
    secPlanet = surface((x*p3rad)+secX, (y*p3rad)+secY, z*p3rad);
    %Set colour data and lighting values
    set(secPlanet,'CData',secTex,'FaceColor','texturemap','EdgeColor','none',...
        'DiffuseStrength', difVal, 'SpecularStrength', p3spec, 'AmbientStrength', ambVal);
    
    %Calculate and draw minute planets moon (purely decorative)
    moon = surface((x*moonRad)+minX+1.25, (y*moonRad)+minY, z*moonRad);
    %Set colour data and lighting values
    set(moon,'CData',moonTex,'FaceColor','texturemap','EdgeColor','none',...
        'DiffuseStrength', difVal, 'SpecularStrength', p1spec, 'AmbientStrength', ambVal);
   
    %Rotate objects
    rotate(sun,[0 0 -1],1)
    %Rotate hour planet
    hourCentre = [hourX, hourY, 0];
    rotate(hourPlanet, [0 0 -1], p1r,hourCentre)
    p1r = p1r + p1rotSpeed;
    %Rotate minute planet
    minCentre = [minX, minY, 0];
    rotate(minPlanet, [0 0 -1], p2r,minCentre)
    p2r = p2r + p2rotSpeed;    
    %Rotate second planet
    secCentre = [secX, secY, 0];
    rotate(secPlanet, [0 0 -1], p3r,secCentre)
    p3r = p3r + p3rotSpeed;
    %Rotate moon
    moonCentre = minCentre;
    rotate(moon, [0 -0.5 -0.5], mr, moonCentre);
    mr = mr + 2;
    
    pause(0.001); %Pause for animation
    
    %Clear planets for next draw (if loop is still running)
    if ~KEY_IS_PRESSED
        delete(hourPlanet); delete(minPlanet); 
        delete(secPlanet); delete(moon);
    end
end

%Change label once while loop is exited (if the figure still exists)
if ~isempty(findall(0,'Type','Figure'))
    title('Time has been stopped.');
end