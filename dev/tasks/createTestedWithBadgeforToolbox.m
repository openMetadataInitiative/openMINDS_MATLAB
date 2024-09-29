function createTestedWithBadgeforToolbox(versionNumber, rootDir)
%createTestedWithBadgesforToolbox - Take the test reports from the runs against 
% multiple MATLAB releases, and generate the "Tested with" badge
%
%   Adapted from: https://github.com/mathworks/climatedatastore/tree/main/buildUtilities
    
    arguments
        versionNumber (1,1) string
        rootDir (1,1) string {mustBeFolder} = ommtools.getProjectRootDir()
    end
    
    releasesTestedWith = "";
    releasesFailed = 0;
    % Go through the R2* directories and extract the failed test info
    releaseDirectoryInfo = dir(fullfile(rootDir, "reports"));
    % Select only folders
    releaseDirectoryInfo = releaseDirectoryInfo([releaseDirectoryInfo.isdir]);
    % with a name like R2*
    releaseDirectoryInfo = releaseDirectoryInfo(startsWith(string({releaseDirectoryInfo.name}), "R2", "IgnoreCase", true));

    % Sort releases newest to oldest
    [~, ix] = sort(string({releaseDirectoryInfo.name}), "descend");
    releaseDirectoryInfo = releaseDirectoryInfo(ix);
    
    % go through the directories and check if tests passed
    for iReleaseDirectoryInfo = 1:numel(releaseDirectoryInfo)
        releaseName = string(releaseDirectoryInfo(iReleaseDirectoryInfo).name);
        testresultsFilename = fullfile(releaseDirectoryInfo(iReleaseDirectoryInfo).folder, releaseName, "test-results.xml");
        % Read the test results file
        testResults = readstruct(testresultsFilename);
        % If no tests failed, errors, or were skipped, then add it to the list
        if testResults.testsuite.errorsAttribute == 0 && testResults.testsuite.failuresAttribute == 0 && testResults.testsuite.skippedAttribute == 0
            if releasesTestedWith ~= ""
                % Insert the seperator between released after the first one
                releasesTestedWith = releasesTestedWith + " | ";
            end
            releasesTestedWith = releasesTestedWith + releaseName;
        else
            releasesFailed = releasesFailed + 1;
        end
    end
    if releasesTestedWith ~= ""
        switch releasesFailed 
            case 0
                badgecolor = "green";
            case 1
                badgecolor = "orange";
            case 2
                badgecolor = "yellow";
            otherwise
                badgecolor = "red";
        end

        outputDirectory = fullfile(rootDir, '.github', 'badges', versionNumber);
        utility.writeBadgeJSONFile("tested with", releasesTestedWith, badgecolor,...
            "OutputFolder", outputDirectory)
    end
end
