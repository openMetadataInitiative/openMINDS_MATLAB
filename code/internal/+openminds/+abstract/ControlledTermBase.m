classdef (Abstract) ControlledTermBase < openminds.abstract.Schema
%ControlledTermBase Shared behavior for controlled term base classes.

    properties (Access = protected)
        Required = {'name'}
    end

    properties (SetAccess = protected, Hidden) % Todo: Same as id, clean up
        at_id
    end

    properties (Constant, Hidden)
        LINKED_PROPERTIES = struct()
        EMBEDDED_PROPERTIES = struct()
    end

    properties (Abstract, Constant, Hidden)
        CONTROLLED_INSTANCES
    end

    methods (Access = protected)
        function initializeControlledTerm(obj, instanceSpec, propValues)
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
                    if startsWith(instanceSpec, openminds.constant.BaseURI)
                        obj.deserializeFromName(instanceSpec);
                    elseif isfile( instanceSpec )
                        error('OPENMINDS_MATLAB:ControlledTerm:Initialize', ...
                            'Filepath input is not supported.')
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
                        if isfield(instanceSpec(i), 'at_id')
                            iri = instanceSpec(i).at_id;
                        elseif isfield(instanceSpec(i), 'x_id')
                            iri = instanceSpec(i).x_id;
                        end
                        obj(i).deserializeFromName(iri);
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
        function deserializeFromName(obj, instanceName)

            import openminds.internal.getControlledInstance
            import openminds.internal.utility.getSchemaName

            instanceName = char(instanceName);
            instanceIRI = "";
            schemaName = getSchemaName(class(obj));

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
            instanceIRI = openminds.constant.BaseURI + "/instances/" ...
                + openminds.abstract.ControlledTermBase.getInstanceTypeName(schemaName) ...
                + "/" + string(instanceName);
        end

        function typeName = getInstanceTypeName(schemaName)
            typeName = char(schemaName);
            if ~strcmp(upper(typeName(1:2)), typeName(1:2))
                typeName(1) = lower(typeName(1));
            end
            typeName = string(typeName);
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
