function this = findOverlapsThirdPass(this)
% FINDOVERLAPSTHIRDPASS - delete lines contained in other lines
    import LineBreaker.*;
    
    n = size(this.TextBBoxes,1);
    A = zeros(n,n);
    for j = 1:n
        for k = 1:n
            A(j,k) = isProperSubBox(this.TextBBoxes(j,:), ...
                                    this.TextBBoxes(k,:));
        end
    end
    idx = max(A,[],2);
    idx = find(idx);
    disp("Deleting " + numel(idx) + " lines contained in other lines");

    this.TextBBoxes(idx,:) = [];
end

