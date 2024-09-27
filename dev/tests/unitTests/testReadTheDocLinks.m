classdef testReadTheDocLinks < matlab.unittest.TestCase

    properties
        % BaseUrl - Base URL for the openMINDS oneline documentation
        BaseUrl = openminds.internal.constants.url.OpenMindsDocumentation
    end

    methods (Test)

        function testDocumentationUrl(testCase)
            webread(testCase.BaseUrl);
        end

        function testSchemaDocLink(testCase)
            import openminds.internal.utility.getSchemaDocLink
            
            url = getSchemaDocLink(...
                "openminds.core.Subject", ...
                "Raw URL");

            webread(url);
        end

        function testSchemaDocLinkUBERONParcellation(testCase)
            import openminds.internal.utility.getSchemaDocLink
            
            url = getSchemaDocLink(...
                "openminds.controlledterms.UBERONParcellation", ...
                "Raw URL");

            webread(url);
        end

        function testPropertyDoclink(testCase)
            import openminds.internal.utility.getSchemaDocLink
            
            url = getSchemaDocLink(...
                "openminds.internal.mixedtype.datasetversion.Author", ...
                "Raw URL");
            
            webread(url);
        end

        function testEarlierVersions(testCase)
            import openminds.internal.utility.getSchemaDocLink

            versionNumbers = openminds.internal.constants.Models.VERSION_NUMBERS;
            
            for i = versionNumbers
                selectOpenMindsVersion(i)

                url = getSchemaDocLink(...
                    "openminds.core.Subject", ...
                    "Raw URL");

                webread(url);
            end
        end
    end
end
