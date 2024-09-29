function rootFolder = getProjectRootDir()
    scriptFolder = fileparts(mfilename('fullpath'));
    % Assumes project root directory is 3 levels up from script location
    rootFolder = fileparts(fileparts(fileparts(scriptFolder)));
    L = dir(rootFolder);
    assert(all(contains( {'code', 'dev'}, {L.name})), ...
        'Expected project root directory to contain "code" and "dev" folder.');
end