function result = testDocLinks()
% testDocLinks - Run test for openMINDS Read The Docs links
    projectDirectory = ommtools.getProjectRootDir();

    addpath( fullfile(projectDirectory, 'code') );
    openminds.startup()

    testDirectoryPath = fullfile(projectDirectory, 'tools', 'tests');
    addpath(genpath( testDirectoryPath ));

    testCase = testReadTheDocLinks();
    result = run(testCase);
end
