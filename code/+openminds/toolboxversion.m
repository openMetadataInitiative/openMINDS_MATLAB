function versionStr = toolboxversion()
    rootPath = openminds.internal.rootpath();
    contentsFile = fullfile(rootPath, 'Contents.m');

    fileStr = fileread(contentsFile);
   
    mathcedStr = regexp(fileStr, 'Version \d*\.\d*\.\d*', 'match');
    versionStr = mathcedStr{1};
end