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
                % Every openMINDS type reaches openminds.Node, a controlled
                % term through the abstract classes of its module. Ask for all
                % ancestors rather than the direct superclasses, so the answer
                % does not depend on how deep the hierarchy happens to be.
                tf = any(strcmp(superclasses(className), 'openminds.Node'));
            end
        end
    end
end
