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
        function instance = createInstance(obj)
        % createInstance - Create a new instance
            if isscalar(obj)
                instance = feval(obj.ClassName);
            else
                error('Can not create instances for list of types')
            end
        end

        function tf = ismissing(obj)
            tf = strcmp(obj.ClassName, 'None');
        end

        function name = getTypeName(obj)
            name = openminds.internal.utility.getTypeName(obj.ClassName);
        end

        function moduleName = getModule(obj)
            splitClassName = split(obj.ClassName, '.');
            moduleName = openminds.enum.Modules(splitClassName{2});
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

            % Documents written for an older model use a different
            % namespace. Both are accepted: the type name is the last
            % segment either way, and it is resolved against the active
            % model. That is a name match, not a migration. A type the
            % active model does not have is rejected below; a property it
            % does not have is dropped by fromStruct and reported by the
            % deserializer; a property whose declaration changed fails on
            % assignment and is reported as an unreadable node.
            knownBaseURIs = openminds.constant.BaseURI("v1") + "/" | ...
                            openminds.constant.BaseURI("v4") + "/";

            isKnownNamespace = startsWith(typeName, knownBaseURIs);
            if ~all(isKnownNamespace)
                error('OPENMINDS_MATLAB:Types:InvalidAtType', ...
                    'Expected @type to start with "%s" or "%s". Got "%s".', ...
                    openminds.constant.BaseURI("v1"), ...
                    openminds.constant.BaseURI("v4"), ...
                    typeName(find(~isKnownNamespace, 1)))
            end

            if numel(typeName) > 1
                typeEnum = arrayfun(@(str) openminds.enum.Types.fromAtType(str), typeName);
                return
            end
        
            splitName = strsplit(typeName, '/');

            try
                typeEnum = openminds.enum.Types(splitName{end});
            catch
                error('OPENMINDS_MATLAB:Types:UnknownAtType', ...
                    ['"%s" does not name a type in version "%s" of the ', ...
                    'openMINDS model.'], splitName{end}, openminds.getModelVersion())
            end
        end
    end
end
