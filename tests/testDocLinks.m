function result = testDocLinks()

    parentDirectoryPath = fileparts( fileparts(mfilename('fullpath')) );
    
    codeDirectoryPath = fullfile(parentDirectoryPath, 'code');
    testDirectoryPath = fullfile(parentDirectoryPath, 'tests');

    addpath(genpath( codeDirectoryPath ));
    addpath(genpath( testDirectoryPath ));

    testCase = testReadTheDocLinks();
    result = run(testCase);
end


