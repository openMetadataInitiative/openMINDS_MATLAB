function tf = isSchemaClassName(fullSchemaName)
%isSchemaClassName Check if name is MATLAB full class name for schema

    arguments
        fullSchemaName (1,1) string
    end

    tf = false;

    if startsWith(fullSchemaName, "openminds.")
        mc = meta.class.fromName(fullSchemaName);
        if ~isempty(mc)
            if ~mc.Abstract
                superClassNames = {mc.SuperclassList.Name};
                if any(strcmp(superClassNames, 'openminds.abstract.Schema')) || ...
                        any(strcmp(superClassNames, 'openminds.abstract.ControlledTerm'))
                    tf = true;
                end
            end
        end
    end
end
