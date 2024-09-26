function S = listSchemasWithNonGenericLabel()
    
    moduleName = "core";
    
    schemaTable = openminds.internal.utility.dir.listSourceSchemas();
    schemaTable = schemaTable(schemaTable.ModuleName == moduleName, :);

    numSchemas = size(schemaTable, 1);

    tempsavepath = tempname;
    tempsavepath = [tempsavepath, '.mat'];
    
    %disp(tempsavepath)
    cleanupObj = onCleanup(@(filepath)delete(tempsavepath));

    numTestsFailed = 0;
    numTestsTotal = 0;

    C = cell(0, 4);
    count = 0;
    S = struct;

    for i = 1:numSchemas

        iSchemaName = schemaTable{i, "SchemaName"};
        iModelName = schemaTable{i, "ModuleName"};
        iSubmoduleName = schemaTable{i, "SubModuleName"};
        
        schemaClassFunctionName = openminds.internal.utility.string.buildClassName(iSchemaName, iSubmoduleName, iModelName);
        schemaFcn = str2func(schemaClassFunctionName);
        
        mc = meta.class.fromName(schemaClassFunctionName);
        if mc.Abstract; continue; end
        
        try
            count = count+1;
            itemPreSave = schemaFcn();

            if isprop(itemPreSave, 'lookupLabel')
                S.(iSchemaName).propertyName = "lookupLabel";
                S.(iSchemaName).stringFormat = "sprintf('%s', lookupLabel)";

                %pass
            elseif isprop(itemPreSave, 'fullName')
                S.(iSchemaName).propertyName = 'fullName';
                S.(iSchemaName).stringFormat = "sprintf('%s', fullName)";

                %pass
            elseif isprop(itemPreSave, 'identifier')
                S.(iSchemaName).propertyName = 'identifier';
                S.(iSchemaName).stringFormat = "sprintf('%s', identifier)";
                
                %pass
            elseif isprop(itemPreSave, 'name')
                S.(iSchemaName).propertyName = 'name';
                S.(iSchemaName).stringFormat = "sprintf('%s', name)";

                %pass
            else

                S.(iSchemaName).propertyName = '';
                S.(iSchemaName).stringFormat = "";

                fprintf('%s\n', iSchemaName)
            end

        catch ME

            fprintf('Could not create schema %s\n', iSchemaName)
        end
    end

    %T = cell2table(C, 'VariableNames', {'SchemaName', 'Failure point', 'Error Message', 'Extended Error'});
    %fprintf('Number of tests that failed: %d/%d\n', numTestsFailed, numTestsTotal)
end
