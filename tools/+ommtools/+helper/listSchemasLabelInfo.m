function T = listSchemasLabelInfo(options)
% listSchemasLabelInfo - Return a table with information about types and
% their label property (if they have a "standard" label property)
    arguments
        options.Modules (1,1) string = "core" % Todo: Support list, use module enum
        options.ShowNonGenericOnly (1,1) logical = true
    end
    
    typesTable = openminds.internal.utility.dir.listSourceSchemas();
    typesTable = typesTable(typesTable.ModuleName == options.Modules, :);

    numSchemas = size(typesTable, 1);

    count = 0;
    S = struct('TypeName', {}, 'PropertyName', {}, 'StringFormat', {}, 'AllPropertyNames', {});

    for i = 1:numSchemas

        iTypeName = typesTable{i, "SchemaName"};
        iModuleName = typesTable{i, "ModuleName"};
        iSubmoduleName = typesTable{i, "SubModuleName"};
        
        typeClassFunctionName = openminds.internal.utility.string.buildClassName(iTypeName, iSubmoduleName, iModuleName);
        typeConstructorFcn = str2func(typeClassFunctionName);
        
        mc = meta.class.fromName(typeClassFunctionName);
        if mc.Abstract; continue; end
        
        count = count+1;
        emptyInstance = typeConstructorFcn();

        S(count).TypeName = iTypeName;
        S(count).AllPropertyNames = string(strjoin(properties(emptyInstance), ', '));

        if isprop(emptyInstance, 'lookupLabel')
            S(count).PropertyName = "lookupLabel";
            S(count).StringFormat = "sprintf('%s', lookupLabel)";

        elseif isprop(emptyInstance, 'fullName')
            S(count).PropertyName = 'fullName';
            S(count).StringFormat = "sprintf('%s', fullName)";

        elseif isprop(emptyInstance, 'identifier')
            S(count).PropertyName = 'identifier';
            S(count).StringFormat = "sprintf('%s', identifier)";

        elseif isprop(emptyInstance, 'name')
            S(count).PropertyName = 'name';
            S(count).StringFormat = "sprintf('%s', name)";
        
        else
            S(count).PropertyName = "";
            S(count).StringFormat = "";
        end
    end
    T = struct2table(S);

    if options.ShowNonGenericOnly
        T = T(T.PropertyName=="", :);
    end
end
