classdef TypesEnumeration

    properties (SetAccess=immutable)
        ClassName (1,1) string
        AliasClassName (1,1) string
        TypeURI (1,1) string
    end

    methods
        function obj = TypesEnumeration(name)
            obj.ClassName = name;
            obj.AliasClassName = obj.createAliasClassName();
            obj.TypeURI = obj.getTypeURI();
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

        function typeURI = getTypeURI(obj)
            if obj.ClassName == "None"
                typeURI = "None";
            else
                typeURI = eval(sprintf('%s.X_TYPE', obj.ClassName));
            end
        end
    end

    methods (Static)
        function typeEnum = fromClassName(className)
        % fromClassName - Get a Type enum from a class name
        %
        % Syntax:
        %   typeEnum = openminds.enum.Types.fromClassName(className) Converts 
        %   the provided class name(s) into the appropriate enumeration value (s).
        %
        % Input Arguments:
        %   className - A string array representing the class name(s) to be
        %              converted.
        %
        % Output Arguments:
        %   typeEnum - The corresponding enumeration value(s) from 
        %              openminds.enum.Types.
        %
        % Example:
        %
        %  openminds.enum.Types.fromClassName("openminds.core.Person")
        %  
        %  ans = 
        % 
        %    Types enumeration
        % 
        %       Person

            arguments
                className (1,:) string
            end

            if numel(className) > 1
                typeEnum = arrayfun(@(str) openminds.enum.Types.fromClassName(str), className);
                return
            end

            splitName = strsplit(className, '.');
            typeEnum = openminds.enum.Types(splitName{end});
        end

        function typeEnum = fromAtType(typeName)
        % fromAtType - Convert an @type string to its corresponding enumeration.
        %
        % Syntax:
        %   typeEnum = openminds.enum.Types.fromAtType(typeName) Converts the 
        %   provided @type string into the appropriate enumeration value.
        %
        % Input Arguments:
        %   typeName - A string array representing the @type to be converted.
        %              The @type URI is expected to match Base URI for the 
        %              currently active openMINDS version
        %
        % Output Arguments:
        %   typeEnum - The corresponding enumeration value(s) from 
        %              openminds.enum.Types.
        %
        % Example:
        %
        %  openminds.enum.Types.fromAtType("https://openminds.om-i.org/types/Person")
        %  
        %  ans = 
        % 
        %    Types enumeration
        % 
        %       Person
        
            arguments
                typeName (1,:) string
            end
        
            assert(all(startsWith(typeName, openminds.constant.BaseURI)), ...
                'OPENMINDS_MATLAB:Types:InvalidAtType', ...
                'Expected @type to start with "%s"', openminds.constant.BaseURI)
       
            if numel(typeName) > 1
                typeEnum = arrayfun(@(str) openminds.enum.Types.fromAtType(str), typeName);
                return
            end
        
            splitName = strsplit(typeName, '/');
            typeEnum = eval(sprintf('openminds.enum.Types.%s', splitName{end}));
        end
    end
end
