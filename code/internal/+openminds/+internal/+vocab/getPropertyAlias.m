function propertyAlias = getPropertyAlias(propertyName, options)
    
    arguments
        propertyName (1,1) string
        options.Alias (1,1) string {mustBeMember(options.Alias, ["name", "label"])} = "name"
        options.Plural = false
    end

    persistent propertiesVocab aliasMap

    if isempty(propertiesVocab)
        propertiesVocab = openminds.internal.vocab.loadVocabJson("properties");

        C = struct2cell(propertiesVocab);
        fields = ["label", "labelPlural", "name", "namePlural"];
        for i = 1:numel(C)
            s = struct;
            for j = 1:numel(fields)
                if isfield(C{i}, fields(j))
                    s.(fields(j)) = string( C{i}.(fields(j)) );
                else
                    s.(fields(j)) = "";
                end
            end
            C{i} = s;
        end
        S = [C{:}];
        aliasMap = dictionary();

        propertyNames = [S.name];
        aliasMap(propertyNames) = [C{:}];
    end
    
    aliasType = options.Alias;
    if options.Plural
        aliasType = sprintf("%sPlural", aliasType);
    end

    propertyAlias = aliasMap(propertyName).(aliasType);

    if numel(propertyName) == 1
        return
    elseif isempty(propertyName)
        throwEmptyPropertyNameException(propertyName);
    else
        throwMultiplePropertyNamesException(propertyName);
    end
end

function throwEmptyPropertyNameException(propertyNameAlias)
    error('OPENMINDS:PropertyNameNotFound', 'No property name matching "%s" was found.', propertyNameAlias);
end

function throwMultiplePropertyNamesException(propertyNameAlias)
    error('OPENMINDS:MultiplePropertyNamesFound', 'Multiple property names matched "%s".', propertyNameAlias)
end
