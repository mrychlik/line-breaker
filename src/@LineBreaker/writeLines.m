function this = writeLines(this, dirname)
    lines = this.ImageLines;
    for j=1:numel(lines)
        filepath = fullfile(dirname,sprintf('line%03d.png',j));
        if exist(filepath,'file') == 2
        end
        imwrite(lines{j},filepath,'PNG'),
        disp("File " + filepath + " was written.");
    end
end