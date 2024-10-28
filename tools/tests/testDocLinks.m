function result = testDocLinks()
% testDocLinks - Run test for openMINDS Read The Docs links
    projectDirectory = ommtools.getProjectRootDir();    

    addpath( fullfile(projectDirectory, 'code') );
    addpath( fullfile(projectDirectory, 'code', 'internal') );
    openminds.startup()

    testDirectoryPath = fullfile(projectDirectory, 'tools', 'tests');
    addpath(genpath( testDirectoryPath ));

    testCase = testReadTheDocLinks();
    result = run(testCase);
end


