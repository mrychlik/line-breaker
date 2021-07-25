function absPath = getAbsPath(obj)
% getAbsPath - get absolute path of a file

    getAbsFolderPath = @(y) unique(arrayfun(@(x) x.folder, dir(y), 'UniformOutput', false));
    getAbsFilePath = @(y) arrayfun(@(x) fullfile(x.folder, x.name), dir(y), 'UniformOutput', false);
    if isfolder(obj)
        absPath = getAbsFolderPath(obj);
    elseif isfile(obj)
        absPath = getAbsFilePath(obj);
    else
        error('The specified object does not exist.');
    end
    absPath = absPath{1};
end

