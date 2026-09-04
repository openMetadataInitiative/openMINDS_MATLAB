function tf = isTypeClassName(className)
%isTypeClassName Check whether a name is the full MATLAB class name of an openMINDS type

    arguments
        className (1,1) string
    end

    tf = false;

    if startsWith(className, "openminds.")
        mc = meta.class.fromName(className);
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
