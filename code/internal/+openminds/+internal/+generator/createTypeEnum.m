function createTypeEnum()
% createTypeEnum - 
    templateFilePath = fullfile(openminds.internal.rootpath, 'internal', ...
        '+openminds', '+internal', '+generator', 'templates', 'Types.mtemplate');
    
    classDefStr = fileread(templateFilePath);
    
    schemaFilePath = fullfile(openminds.internal.rootpath, 'schemas', 'latest', '+openminds');
    L = recursiveDir(schemaFilePath, IgnoreList='Contents.m', FileType='m', OutputType='RelativeFilePath');
    
    [packageNames, names] = fileparts(L);
    
    packageNames = strcat("openminds", strrep(strrep(packageNames, '+', ''), filesep, '.'));
    
    classNames = packageNames + "." + names;

    % Build enum str:
    lines = repmat("", 1, numel(names));
    for i = 1:numel(lines)
        lines(i) = sprintf("        %s('%s')", names(i), classNames(i));
    end

    classDefStr = insertAfter(classDefStr, sprintf("None('None')\n"), strjoin(lines, newline));

    savePath = fullfile(om.internal.rootpath, '+om', '+enum', 'Types.m');
    fid = fopen(savePath, 'w');
    fwrite(fid, classDefStr);
    fclose(fid);
end