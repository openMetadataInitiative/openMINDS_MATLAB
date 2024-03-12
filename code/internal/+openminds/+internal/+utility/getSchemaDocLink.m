function str = getSchemaDocLink(schemaClass, preferredDocumentation)
    
    if nargin < 2
        %preferences.PreferredDocumentation = 'Command window help';
        preferences.PreferredDocumentation = 'Default browser';
        preferredDocumentation = preferences.PreferredDocumentation;
    end

    if strncmp( schemaClass, 'https', 5)
        schemaClass = convertToMatlabClassname(schemaClass);
    end

    if ~strncmp(schemaClass, 'openminds', 9)
        str = schemaClass; return
    end

    switch preferredDocumentation
        case 'Command window help'
            str = getSimpleHelpLink(schemaClass);

        case 'Help popup'
            str = getHelpPopupLink(schemaClass);

        case 'Matlab web'
            str = getHtmlLink(schemaClass, '-new -notoolbar');

        case 'Default browser'
            str = getHtmlLink(schemaClass, '-browser');

        case "Raw URL"
            str = getHtmlLink(schemaClass, '-api');

    end
end


function str = getSimpleHelpLink(schemaClassName)
    schemaName = openminds.internal.utility.getSchemaName(schemaClassName);
    str = sprintf('<a href="matlab:help %s" style="font-weight:bold">%s</a>', schemaClassName, schemaName);
end

function str = getHelpPopupLink(schemaClassName)
    schemaName = openminds.internal.utility.getSchemaName(schemaClassName);
    str = sprintf('<a href="matlab:helpPopup %s" style="font-weight:bold">%s</a>', schemaClassName, schemaName);
end

function str = getHtmlLink(schemaClassName, browserOption)
    
    persistent schemaManifest
    if isempty(schemaManifest)
        try
            schemaManifest = openminds.internal.loadSchemaManifest("latest");
        catch
            error('Not implemented yet')
            schemaManifest = openminds.internal.buildSchemaManifestFromSourceFiles("latest")
        end
    end

    schemaName = openminds.internal.utility.getSchemaName(schemaClassName);

    isMatch = strcmpi(schemaManifest.Name, string(schemaName));
    version = openminds.getSchemaVersion();

    modelName = schemaManifest{isMatch, "Model"};
    subgroupName = schemaManifest{isMatch, "Group"};
    schemaName = schemaManifest{isMatch, "Name"};

    if contains(schemaClassName, 'mixedtype')
        [~, fragment] = openminds.internal.utility.string.packageParts(schemaClassName);
        url = generateDocumentationUrl(version, modelName, subgroupName, schemaName, fragment);
        displayLabel = fragment;
    else
        url = generateDocumentationUrl(version, modelName, subgroupName, schemaName);
        displayLabel = openminds.internal.utility.getSchemaName(schemaClassName);
    end

    if strcmp(browserOption, '-api')
        str = url;
    else
        str = createLink(url, displayLabel, browserOption);
    end
    
    return

    persistent htmlFileTable
    if isempty(htmlFileTable)
        htmlFileTable = openminds.internal.utility.dir.listSourceSchemas(...
            'SchemaType', 'html', 'SchemaFileExtension', 'html');
    end

    schemaName = openminds.internal.utility.getSchemaName(schemaClassName);

    isMatch = lower(htmlFileTable.SchemaName) == lower(schemaName);
    filepath = htmlFileTable.Filepath(isMatch);
    
    %commandStr = sprintf('web(''%s'', ''%s'')', filepath, browserOption);
    str = sprintf('<a href="matlab:web %s %s" style="font-weight:bold">%s</a>', filepath, browserOption, schemaName);
end

function str = getOnlineHtmlLink(version, modelName, subgroupName, schemaName, browserOption, fragment)
    
    filepath = generateDocumentationUrl(version, modelName, subgroupName, schemaName, fragment);

    str = sprintf('<a href="matlab:web %s %s" style="font-weight:bold">%s</a>', filepath, browserOption, schemaName);
end

function weblink = createLink(urlString, displayLabel, browserOption)
    weblink = sprintf('<a href="matlab:web %s %s" style="font-weight:bold">%s</a>', urlString, browserOption, displayLabel);
end

function urlStr = generateDocumentationUrl(version, modelName, subgroupName, schemaName, fragment)
    
    if nargin < 5
        fragment = '';
    end
    
    import openminds.internal.utility.string.uriJoin
    BASE_URL = openminds.internal.constants.url.OpenMindsDocumentation;

    urlStr = uriJoin(BASE_URL, version, 'schema_specifications', modelName, subgroupName, schemaName);
    urlStr = urlStr + ".html";

    if ~isempty(fragment)
        fragment = openminds.internal.utility.string.camelCase(fragment);
        urlStr = strjoin([urlStr, fragment], '#');
    end
end

function schemaClass = convertToMatlabClassname(schemaClass)
    schemaClass = strrep(schemaClass, 'https://openminds.ebrains.eu/', '');
    splitStr = strsplit(schemaClass, '/');

    modelName = lower(splitStr{1});
    schemaName = splitStr{2};

    schemaClass = strjoin({'openminds', modelName, schemaName}, '.');
end
