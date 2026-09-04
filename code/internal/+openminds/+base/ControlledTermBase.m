classdef (Abstract) ControlledTermBase < openminds.Node
%ControlledTermBase Shared behavior for controlled term base classes.

    properties (Access = protected)
        Required = {'name'}
    end

    properties (SetAccess = protected, Hidden) % Todo: Same as id, clean up
        at_id
    end

    properties (Abstract, Constant, Hidden)
        CONTROLLED_INSTANCES
    end

    methods (Access = protected)
        function obj = initializeControlledTerm(obj, instanceSpec, propValues)
        % initializeControlledTerm - Populate one or more terms from a spec
        %
        %   The object array is returned because a struct array spec
        %   produces one term per element. Expanding obj inside this method
        %   only grows the local copy, so a caller that ignores the return
        %   value keeps just the first element.
            if isstring(instanceSpec) && isscalar(instanceSpec) && instanceSpec == ""
                instanceSpec = string.empty;
            end

            if ~isempty(instanceSpec)
                if ischar(instanceSpec)
                    instanceSpec = string(instanceSpec);
                end

                if isstring( instanceSpec ) && ~ismissing(instanceSpec)
                    % Check IRI first, because isfile will also check IRIs
                    % and that is expensive (we only want to check local
                    % files anyway)
                    if startsWith(instanceSpec, openminds.constant.BaseIRI)
                        obj.deserializeFromName(instanceSpec);
                    elseif isfile( instanceSpec )
                        obj.load( instanceSpec ) % todo: Not implemented??
                    else
                        % Deserialize from name of controlled instance
                        obj.deserializeFromName(instanceSpec);
                    end
                elseif isstruct( instanceSpec ) && (isfield(instanceSpec, 'at_id') || isfield(instanceSpec, 'x_id'))
                    numInstances = numel(instanceSpec);
                    if numInstances > 1
                        obj(numInstances) = feval(class(obj));
                    end
                    for i = 1:numel(instanceSpec)
                        obj(i).initializeFromStructure(instanceSpec(i));
                    end
                else
                    error('openMINDS:ControlledTerm:InvalidInput', ...
                        'Expected instance spec to be a name, a filename, or a structure or structure array with an `at_id` or `x_id` field.')
                end

                names = fieldnames(propValues);
                obj.warnIfPropValuesSupplied(names)
            else
                obj.set(propValues)
                if ismissing(obj.id) || obj.id == ""
                    obj.id = obj.generateInstanceId();
                end
            end
        end

        function str = getDisplayLabel(obj)
            str = sprintf('%s', obj.name);
        end
    end

    methods (Hidden)
        function str = char(obj)
            str = char(string(obj.name));
        end
    end

    methods (Access = private)
        function initializeFromStructure(obj, structure)
        % initializeFromStructure - Populate this term from a decoded document
        %
        %   A structure that carries property values is a serialized
        %   instance and is authoritative: its values are used as they
        %   stand. That is the only way a term defined by a user, which by
        %   definition is not in the controlled instance library, can
        %   survive being written out and read back.
        %
        %   A structure that carries nothing but an identifier is a
        %   reference. There is no data to take from it, so the term is
        %   looked up in the controlled instance library instead.

            identifier = openminds.internal.utility.getStructIdentifier(structure);

            if openminds.base.ControlledTermBase.isBareReference(structure)
                obj.deserializeFromName(identifier);
                return
            end

            obj.fromStruct(structure);

            % fromStruct assigns the identifier from an at_id or x_id
            % field, but a document written without identifiers has
            % neither, and the constructor has already generated one.
            if ~openminds.base.ControlledTermBase.isEmptyValue(identifier)
                obj.assignInstanceId(identifier);
            end
        end

        function deserializeFromName(obj, instanceName)

            import openminds.internal.getControlledInstance
            import openminds.internal.utility.getTypeName

            instanceName = char(instanceName);
            instanceIRI = "";
            schemaName = getTypeName(class(obj));

            if openminds.utility.isIRI(instanceName)
                if openminds.utility.isInstanceIRI(instanceName)
                     instanceIRI = string(instanceName);
                     [~, instanceName] = openminds.utility.parseInstanceIRI(instanceName);
                else
                    obj.id = instanceName;
                    return
                end
            end

            if ~any(strcmp(obj.CONTROLLED_INSTANCES, instanceName))
                % Try to make a valid name
                instanceName = strrep(instanceName, ' ', '');
                instanceName = matlab.lang.makeValidName(instanceName, 'ReplacementStyle', 'delete');
            end

            % Todo: Use a proper deserializer
            isMatchingInstance = strcmpi(obj.CONTROLLED_INSTANCES, instanceName);
            if any(isMatchingInstance)
                instanceName = obj.CONTROLLED_INSTANCES(find(isMatchingInstance, 1, 'first'));
                obj.name = instanceName;
                if instanceIRI == ""
                    obj.id = obj.createControlledInstanceIRI(schemaName, instanceName);
                else
                    obj.id = instanceIRI;
                end

                try
                    data = getControlledInstance(instanceName, schemaName, 'controlledTerms');
                catch
                    % Known instance names are sufficient identifiers. The
                    % JSON-LD instance file is only used to enrich metadata.
                    return
                end
            else
                warning('No matching instances were found for name "%s"', instanceName)
                return
                % error('Deserialization from user instance is not implemented yet')
            end

            propNames = [{'at_id'}, properties(obj)'];
            for i = 1:numel(propNames)
                if isfield(data, propNames{i}) && ~obj.isEmptyValue(data.(propNames{i}))
                    obj.(propNames{i}) = data.(propNames{i});
                end
            end

            if instanceIRI == "" && ~obj.isEmptyValue(obj.at_id)
                obj.id = obj.at_id;
            end
        end
    end

    methods (Static, Access = private)
        function instanceIRI = createControlledInstanceIRI(schemaName, instanceName)
            instanceIRI = openminds.constant.BaseIRI + "/instances/" ...
                + openminds.base.ControlledTermBase.getInstanceTypeName(schemaName) ...
                + "/" + string(instanceName);
        end

        function typeName = getInstanceTypeName(schemaName)
            typeName = char(schemaName);
            if ~strcmp(upper(typeName(1:2)), typeName(1:2))
                typeName(1) = lower(typeName(1));
            end
            typeName = string(typeName);
        end

        function tf = isBareReference(structure)
        % isBareReference - True when a document carries no property values
        %
        %   Such a document points at a term without describing it, so
        %   there is nothing to populate the instance from. The document
        %   may still list every property with an empty value, which is
        %   what a serializer writes for an unpopulated term when it
        %   includes empty properties, so the test is on values rather
        %   than on the presence of fields.

            valueFields = setdiff(string(fieldnames(structure))', ...
                openminds.internal.utility.jsonLdKeywordFields());
            hasValue = arrayfun(@(name) ...
                ~openminds.base.ControlledTermBase.isEmptyValue(structure.(name)), valueFields);
            tf = ~any(hasValue);
        end

        function tf = isEmptyValue(value)
            if isempty(value)
                tf = true;
            elseif isstring(value)
                tf = all(ismissing(value) | value == "");
            else
                tf = false;
            end
        end
    end
end
