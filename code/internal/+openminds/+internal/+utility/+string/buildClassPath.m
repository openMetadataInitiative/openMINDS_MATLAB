function filePath = buildClassPath(schemaClassName, schemaCategory, schemaModule)
%BUILDCLASSPATH Summary of this function goes here
%   Detailed explanation goes here
    
    arguments
        schemaClassName
        schemaCategory
        schemaModule
    end

    schemaClassName = openminds.internal.utility.string.pascalCase(schemaClassName);
    
    schemaCategory = strrep( schemaCategory, 'schemas', ''); % Todo ??
    schemaCategory = lower( schemaCategory );
    schemaModule = lower(schemaModule);
    rootPath = openminds.internal.PathConstants.MatlabSchemaFolder;
    folderPath = fullfile( rootPath, '+openminds', ['+', schemaModule] );

    if ~isempty(schemaCategory) % Append schema category subfolder if relevant
        folderPath = fullfile( folderPath, ['+', schemaCategory]);
    end
    
    filePath = fullfile(folderPath, [schemaClassName, '.m']);
end
