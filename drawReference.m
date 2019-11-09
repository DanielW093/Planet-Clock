function drawReference(clockRadius, clockPoints, p1orbDist, p2orbDist, p3orbDist, p1rad, p2rad, p3rad)

%Draw reference object
refCol = 'w'; refWid = 1.0; %Colour and line width
%Pad planet radii
padVal = 0.15;
p1rad = p1rad + padVal; p2rad = p2rad + padVal; p3rad = p3rad + padVal;

%Calculate a series of concentric circles
[p3startX, p3startY] = circleCoord(0, 0, p3orbDist+p3rad, clockPoints);
[p3stopX, p3stopY] = circleCoord(0, 0, p3orbDist-p3rad, clockPoints);
[p2startX, p2startY] = circleCoord(0, 0, p2orbDist+p2rad, clockPoints);
[p2stopX, p2stopY] = circleCoord(0, 0, p2orbDist-p2rad, clockPoints);
[p1startX, p1startY] = circleCoord(0, 0, p1orbDist+p1rad, clockPoints);
[p1stopX, p1stopY] = circleCoord(0, 0, p1orbDist-p1rad, clockPoints);
[innerX, innerY] = circleCoord(0, 0, 1.5, clockPoints);

%Draw concentric circles
line(p3startX, p3startY, 'LineWidth', refWid, 'Color', refCol);
line(p3stopX, p3stopY, 'LineWidth', refWid, 'Color', refCol);
line(p2startX, p2startY, 'LineWidth', refWid, 'Color', refCol);
line(p2stopX, p2stopY, 'LineWidth', refWid, 'Color', refCol);
line(p1startX, p1startY, 'LineWidth', refWid, 'Color', refCol);
line(p1stopX, p1stopY, 'LineWidth', refWid, 'Color', refCol);
line(innerX, innerY, 'LineWidth', refWid, 'Color', refCol);

%Concatenate matrices for lines
line1X = vertcat(p3stopX, p2startX);
line1Y = vertcat(p3stopY, p2startY);
line2X = vertcat(p2stopX, p1startX);
line2Y = vertcat(p2stopY, p1startY);
line3X = vertcat(p1stopX, innerX);
line3Y = vertcat(p1stopY, innerY);

%Draw hour lines
for n = 1:clockPoints
    modulo = mod(n-1, 5); %Is the current point a multiple of five?
    if modulo == 0
        %Draw lines
        line(line1X(:,n), line1Y(:,n), 'LineWidth', refWid, 'Color', refCol);
        line(line2X(:,n), line2Y(:,n), 'LineWidth', refWid, 'Color', refCol);
        line(line3X(:,n), line3Y(:,n), 'LineWidth', refWid, 'Color', refCol);
    end
end

%Number circle
[nX, nY] = circleCoord(0,0,clockRadius+0.5, clockPoints);
for n = 1:12
    %Draw numbers on hour lines
    text(nX(n*5+1),nY(n*5+1)+0.25, num2str(n),'HorizontalAlignment', 'center','FontName' ...
        ,'Bauhaus 93','FontSize', 22, 'Color', refCol);
end

end

