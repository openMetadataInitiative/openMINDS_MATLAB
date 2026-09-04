function filePath = buildClassPath(schemaClassName, schemaCategory, schemaModule)
%buildClassPath File path of the generated class for a type
%
%   filePath = buildClassPath(schemaClassName, schemaCategory, schemaModule)
%   places the class under the +openminds/+<module>[/+<category>] package
%   of the generated types folder.
    
    arguments
        schemaClassName
        schemaCategory
        schemaModule
    end

    schemaClassName = openminds.internal.utility.string.pascalCase(schemaClassName);
    
    schemaCategory = strrep( schemaCategory, 'schemas', ''); % Todo ??
    schemaCategory = lower( schemaCategory );
    schemaModule = lower(schemaModule);
    rootPath = openminds.internal.constants.Paths.TypesFolder;
    folderPath = fullfile( rootPath, '+openminds', ['+', schemaModule] );

    if ~isempty(schemaCategory) % Append schema category subfolder if relevant
        folderPath = fullfile( folderPath, ['+', schemaCategory]);
    end
    
    filePath = fullfile(folderPath, [schemaClassName, '.m']);
end
