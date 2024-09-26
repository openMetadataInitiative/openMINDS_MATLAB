function className = createPropertyLinksetClass(schemaName, propertyName, linkedTypes, allowMultiple)
% createPropertyLinksetClass Create a new linkset class for a given property
%
% Syntax:
%   className = createPropertyLinksetClass(propertyName, linkedTypes)
%
% Inputs:
%   schemaName - The name of the schema the property belongs to
%   propertyName - The name of the property to create a linkedcategory class for
%   linkedTypes - A string array of the types that the property links to
%
% Outputs:
%   className - The name of the newly created linkset class
%
% Example:
%   className = createPropertyLinksetClass('MySchema', 'MyProperty', ["Type1", "Type2"])
%
% See also: openminds.abstract.LinkedCategory
    
    import openminds.internal.generator.utility.cellArrayToTextStringArray
    
    % Ensure property name is PascalCase
    propertyName(1) = upper(propertyName(1));
    
    % Convert the cell array of types to a string representing a string
    % array
    linkedTypes = cellArrayToTextStringArray(linkedTypes);

    packageNames = ["openminds", "internal", "mixedtype", lower(schemaName)];
    packageFolderNames = strcat("+", packageNames);
    
    % Define directory and file paths
    templateDirectory = fullfile(openminds.internal.rootpath(), 'internal', 'resources', 'templates');
    rootTargetDirectory = fullfile(openminds.internal.rootpath(), 'mixedtypes', packageFolderNames{:});
    
    templateFilepath = fullfile(templateDirectory, 'MixedTypeTemplate.m');
    saveFilepath = fullfile(rootTargetDirectory, sprintf('%s.m', propertyName));

    % Read the template
    str = fileread(templateFilepath);

    % Modify the template based on inputs
    str = strrep(str, 'MixedTypeTemplate', propertyName);
    str = strrep(str, '[]', linkedTypes);
    if allowMultiple
        str = strrep(str, 'true', 'false');
    end

    % Save the result to a new class
    if isfile(saveFilepath)
        warning('Property link class already exists for %s', propertyName)
        saveFilepath = strrep(saveFilepath, '.m', sprintf('%02d.m', randi(100) ));
    end
    openminds.internal.utility.filewrite(saveFilepath, str)
    
    className = strjoin([packageNames, propertyName], '.');
end
