classdef TypesEnumeration

    properties (SetAccess=immutable)
        ClassName (1,1) string
        AliasClassName (1,1) string
    end

    methods
        function obj = TypesEnumeration(name)
            obj.ClassName = name;
            obj.AliasClassName = obj.createAliasClassName();
        end
    end

    methods
        function tf = ismissing(obj)
            tf = strcmp(obj.ClassName, 'None');
        end

        function name = getSchemaName(obj)
            name = openminds.internal.utility.getSchemaShortName(obj.ClassName);
        end
    end

    methods (Access = private)
        function aliasClassName = createAliasClassName(obj)
        % createAliasClassName - Creates the alias class name for a type
        %
        % The alias class name does not contain the subgroup name for a
        % metadata type. This name is present in some of the openminds
        % metadata models and not in others, so the AliasClassName may be
        % equal to the ClassName

            if obj.ClassName == "None"
                aliasClassName = "None";
            else
                classNameParts = strsplit(obj.ClassName, '.');
                aliasClassName = strjoin(classNameParts([1,2,end]), '.');
            end
        end
    end

    methods (Static)
        function typeEnum = fromClassName(className)
            
            if ischar(className)
                className = string(className);
            end

            if numel(className) > 1
                if iscell(className); className = string(className); end
                typeEnum = arrayfun(@(str) openminds.enum.Types.fromClassName(str), className);
                return
            end

            splitName = strsplit(className, '.');
            typeEnum = openminds.enum.Types(splitName{end});
        end
    end
end
