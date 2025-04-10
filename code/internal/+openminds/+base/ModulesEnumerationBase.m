classdef ModulesEnumerationBase
    methods
        function types = listTypes(obj)
        % listTypes - List types for this module

            moduleNamespaceName = lower(string(obj));
            
            types = enumeration( 'openminds.enum.Types' );
            classNames = [types.ClassName];
            namespacePrefix = sprintf('openminds.%s', moduleNamespaceName);
            keep = startsWith( classNames, namespacePrefix);
            
            types = types(keep);
        end
    end
end
