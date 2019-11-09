function [x, y] = polar2cart(r,theta)
%Converts polar coordinates(radius and angle in degress) to cartesian coordinates
%Equation for converting angle to x,y coordinates found on a Cornell
%University resource

radians = theta*pi/180;  % translate degrees to radians
x= r*cos(radians);
y= r*sin(radians);
