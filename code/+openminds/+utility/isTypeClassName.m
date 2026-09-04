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
                if any(strcmp(superClassNames, 'openminds.Node')) || ...
                        any(strcmp(superClassNames, 'openminds.base.ControlledTerm'))
                    tf = true;
                end
            end
        end
    end
end
