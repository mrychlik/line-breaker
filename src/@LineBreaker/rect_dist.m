function d = rect_dist(a, b)
% Defines distance on rectangles [xmin, ymin, xmax, ymax]
    ;
    % Compute the bounding box of both
    c(1) = min(a(1), b(1));
    c(2) = min(a(2), b(2));
    c(3) = max(a(3), b(3));
    c(4) = max(a(4), b(4));

    d1 = ((a(4)-a(2))+(b(4)-b(2)))./(c(4)-c(2)); 
    d2 = ((a(3)-a(1))+(b(3)-b(1)))./(c(3)-c(1));    

    d = max(d1,d2);
end