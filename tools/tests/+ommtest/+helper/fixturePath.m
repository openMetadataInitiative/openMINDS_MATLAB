function folderPath = fixturePath()
%fixturePath Folder holding the golden JSON-LD fixtures
%
%   folderPath = ommtest.helper.fixturePath() returns the absolute path of
%   the fixtures folder, resolved relative to this file so it does not
%   depend on the current working folder.

    thisFile = mfilename('fullpath');
    helperFolder = fileparts(thisFile);            % +helper
    packageFolder = fileparts(helperFolder);       % +ommtest
    testsFolder = fileparts(packageFolder);        % tools/tests
    folderPath = string(fullfile(testsFolder, 'fixtures'));
end
