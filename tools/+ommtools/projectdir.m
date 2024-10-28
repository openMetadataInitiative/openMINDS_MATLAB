function rootFolder = projectdir()
    scriptFolder = fileparts(mfilename('fullpath'));
    % Assumes project root directory is 3 levels up from script location
    rootFolder = fileparts(fileparts(scriptFolder));
    L = dir(rootFolder);
    assert(all(contains( {'code', 'tools'}, {L.name})), ...
        'Expected project root directory to contain "code" and "tools" folder.');
end
