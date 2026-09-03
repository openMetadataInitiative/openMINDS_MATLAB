function outputPath = regenerateFixtures(options)
%regenerateFixtures Write the golden JSON-LD fixture for the active model
%
%   ommtest.helper.regenerateFixtures() writes the golden fixture file for
%   the currently active openMINDS model version, from the graph defined by
%   ommtest.helper.buildFixtureCollection.
%
%   Run this after a model version bump, then review the diff. A change in
%   the golden file is a change in the serialized output of the library and
%   should be understood before it is committed.
%
%   Name-Value Arguments:
%     FixtureFolder - Folder to write to. Defaults to the fixtures folder
%                     next to the tests.
%
%   Output Arguments:
%     outputPath - Path of the file that was written.
%
%   See also ommtest.helper.buildFixtureCollection, ommtest.helper.fixturePath

    arguments
        options.FixtureFolder (1,1) string = ommtest.helper.fixturePath()
    end

    if ~isfolder(options.FixtureFolder)
        mkdir(options.FixtureFolder)
    end

    collection = ommtest.helper.buildFixtureCollection();
    outputPath = fullfile(options.FixtureFolder, currentFixtureName());
    collection.save(outputPath);

    fprintf('Wrote fixture: %s\n', outputPath);

    if ~nargout
        clear outputPath
    end
end

function fileName = currentFixtureName()
    fileName = "collection_" + ommtest.helper.fixtureNamespaceTag() + ".jsonld";
end
