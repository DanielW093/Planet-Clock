function [x, y] = circleCoord(cx, cy, r, n)
%Returns co-ordinates for circle with centre position cx, cy of r radius
%with n amount of points

t=linspace(0,2*pi,n+1); %Calculate circle

x=r*sin(t)+cx; %Calculate circle x co-ordinates

y=r*cos(t)+cy; %Calculate circle y co-ordinates

end 