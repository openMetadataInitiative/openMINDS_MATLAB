function result = testDocLinks()

    parentDirectoryPath = fileparts( fileparts(mfilename('fullpath')) );
    
    codeDirectoryPath = fullfile(parentDirectoryPath, 'code');
    testDirectoryPath = fullfile(parentDirectoryPath, 'tests');

    addpath( codeDirectoryPath );
    openminds.internal.startup()
    addpath(genpath( testDirectoryPath ));

    testCase = testReadTheDocLinks();
    result = run(testCase);
end


