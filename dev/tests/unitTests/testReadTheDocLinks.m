classdef testReadTheDocLinks < matlab.unittest.TestCase

    properties (TestParameter)
        modelVersion = num2cell(openminds.internal.constants.Models.VERSION_NUMBERS)
    end

    properties
        % BaseUrl - Base URL for the openMINDS oneline documentation
        BaseUrl = openminds.internal.constants.url.OpenMindsDocumentation
    end

    methods (Test)

        function testDocumentationUrl(testCase)
            try
                webread(testCase.BaseUrl);
            catch ME
                errorMessage = sprintf([...
                    'Failed to read main page of documentation with error:\n', ...
                    '%s'], ME.message);
                testCase.verifyFail(errorMessage)
            end
        end

        function testInvalidDocumentationUrl(testCase)
               
            url = testCase.BaseUrl;
            invalidUrl = replace(url, 'openminds', 'oppenminds');
            
            testCase.verifyError(@(url)webread(invalidUrl), ...
                'MATLAB:webservices:HTTP404StatusCodeError')
        end

        function testSchemaDocLinkUBERONParcellation(testCase)
            import openminds.internal.utility.getSchemaDocLink
            
            url = getSchemaDocLink(...
                "openminds.controlledterms.UBERONParcellation", ...
                "Raw URL");

            try
                webread(url);
            catch ME
                errorMessage = sprintf([...
                    'Failed to read documentation for UBERONParcellation with error:\n', ...
                    '%s'], ME.message);
                testCase.verifyFail(errorMessage)
            end
        end

        function testPropertyDoclink(testCase)
            import openminds.internal.utility.getSchemaDocLink
            
            url = getSchemaDocLink(...
                "openminds.internal.mixedtype.datasetversion.Author", ...
                "Raw URL");
            
            try
                webread(url);
            catch ME
                errorMessage = sprintf([...
                    'Failed to read documentation for author property with error:\n', ...
                    '%s'], ME.message);
                testCase.verifyFail(errorMessage)
            end
        end

        function testInvalidSchemaDocUrl(testCase)
            import openminds.internal.utility.getSchemaDocLink
            
            url = getSchemaDocLink(...
                "openminds.core.Subject", ...
                "Raw URL");

            invalidUrl = replace(url, 'subject', 'subbject');
            
            testCase.verifyError(@(url)webread(invalidUrl), ...
                'MATLAB:webservices:HTTP404StatusCodeError')
        end

        function testSchemaDocLink(testCase, modelVersion)
            import openminds.internal.utility.getSchemaDocLink

            openminds.startup(modelVersion)
            cleanupObj = onCleanup(@(v) openminds.startup("latest"));

            url = getSchemaDocLink(...
                "openminds.core.Subject", ...
                "Raw URL");

            try
                webread(url);
            catch ME
                errorMessage = sprintf([...
                    'Failed to read documentation for Subject type with error:\n', ...
                    '%s'], ME.message);
                testCase.verifyFail(errorMessage)
            end
        end
    end
end
