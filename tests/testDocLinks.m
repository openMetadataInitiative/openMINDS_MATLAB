function result = testDocLinks()

    parentDirectoryPath = fileparts( fileparts(mfilename('fullpath')) );
    
    testDirectoryPath = fullfile(parentDirectoryPath, 'tests');

    addpath( fullfile(parentDirectoryPath, 'code') );
    addpath( fullfile(parentDirectoryPath, 'code', 'internal') );
    openminds.internal.startup()
    addpath(genpath( testDirectoryPath ));

    testCase = testReadTheDocLinks();
    result = run(testCase);
end


