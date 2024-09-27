function testToolbox(options)
    %RUNTESTWITHCODECOVERAGE Summary of this function goes here
    %   Detailed explanation goes here
    
    arguments
        options.HtmlReports (1,1) logical = false;
        options.ReportSubdirectory (1,1) string = "";
    end
    
    import matlab.unittest.TestSuite;
    import matlab.unittest.TestRunner;
    import matlab.unittest.Verbosity;
    import matlab.unittest.plugins.CodeCoveragePlugin;
    import matlab.unittest.plugins.XMLPlugin;
    import matlab.unittest.plugins.codecoverage.CoverageReport;
    import matlab.unittest.plugins.codecoverage.CoberturaFormat;
    import matlab.unittest.selectors.HasTag;
    
    rootDir = string( fileparts(fileparts(mfilename('fullpath'))) );
    testFolder = fullfile(rootDir, "dev", "tests");
    codeFolder = fullfile(rootDir, "code");
    oldpath  = addpath(genpath(testFolder), genpath(codeFolder) );
    finalize = onCleanup(@()(path(oldpath)));

    outputDirectory = fullfile("docs", "reports", options.ReportSubdirectory);
    if isfolder(outputDirectory)
        mkdir(outputDirectory)
    end
    
    suite = TestSuite.fromFolder(fullfile(testFolder, 'unitTests'));

    runner = TestRunner.withTextOutput('OutputDetail', Verbosity.Detailed);

    codecoverageFileName = fullfile(outputDirectory, "codecoverage.xml");
    
    if options.HtmlReports
        htmlReport = CoverageReport(outputDirectory, 'MainFile', "codecoverage.html");
        p = CodeCoveragePlugin.forFolder(codeFolder, "Producing", htmlReport);
        runner.addPlugin(p)
    else
        runner.addPlugin(XMLPlugin.producingJUnitFormat(fullfile(outputDirectory,'test-results.xml')));
        runner.addPlugin(CodeCoveragePlugin.forFolder(codeFolder, 'IncludingSubfolders', true, 'Producing', CoberturaFormat(codecoverageFileName)));
    end
    
    results = runner.run(suite);

    if ~verLessThan('matlab','9.9') && ~isMATLABReleaseOlderThan("R2022a") %#ok<VERLESSMATLAB>
        % This report is only available in R2022a and later.  isMATLABReleaseOlderThan wasn't added until MATLAB 2020b / version 9.9
        results.generateHTMLReport(outputDirectory,'MainFile',"testreport.html");
    end

    numTests = numel(results);
    numPassedTests = sum([results.Passed]);
    numFailedTests = sum([results.Failed]);

    % Generate the JSON files for the shields in the readme.md
    if numFailedTests == 0
        color = "green";
        message = sprintf("%d passed", numPassedTests);
    elseif numFailedTests/numTests > 0.05
        color = "yellow";
        message = sprintf("%d/%d passed", numPassedTests, numTests);
    else
        color = "red";
        message = sprintf("%d/%d passed", numPassedTests, numTests);
    end
    utility.writeBadgeJSONFile("tests", message, color)
    
    results.assertSuccess()
end
