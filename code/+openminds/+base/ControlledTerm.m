classdef (Abstract) ControlledTerm < openminds.Node
%ControlledTerm Shared behavior for every controlled term.

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
                    % An instance IRI of another schema version names the
                    % same instance, so isInstanceIRI, which accepts either
                    % namespace, is consulted as well. The prefix test is
                    % kept alongside it rather than replaced: it also
                    % covers openMINDS IRIs that do not name an instance,
                    % and dropping it would send those to the file check
                    % below.
                    isOpenMindsIRI = ...
                        startsWith(instanceSpec, openminds.constant.BaseIRI) ...
                        || openminds.utility.isInstanceIRI(instanceSpec);

                    if isOpenMindsIRI
                        obj.deserializeFromName(instanceSpec);
                    elseif openminds.base.ControlledTerm.isLocalFile(instanceSpec)
                        obj.load(instanceSpec)
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

            if openminds.base.ControlledTerm.isBareReference(structure)
                obj.deserializeFromName(identifier);
                return
            end

            obj.fromStruct(structure);

            % fromStruct assigns the identifier from an at_id or x_id
            % field, but a document written without identifiers has
            % neither, and the constructor has already generated one.
            if ~openminds.base.ControlledTerm.isEmptyValue(identifier)
                obj.assignInstanceId(identifier);
            end
        end

        function load(obj, filePath)
        % load - Populate this term from a JSON-LD document
        %
        %   A controlled term document describes one term and, apart from
        %   a term suggestion, holds no links, so it reads into a single
        %   instance. Reading is left to the deserializer, which is what
        %   parses the document, dispatches on its @type and wires up any
        %   links; only the values are taken from what it returns, because
        %   a constructor has to populate the object it was called on.
        %
        %   A document holding more than one instance is a collection's
        %   job: see openminds.Collection.load.

            instances = openminds.internal.store.loadInstances(filePath);

            if ~isscalar(instances)
                error('openMINDS:ControlledTerm:MultipleInstancesInDocument', ...
                    ['"%s" holds %d instances. A term is a single instance, ', ...
                     'so use openminds.Collection to read a document that ', ...
                     'holds more than one.'], filePath, numel(instances))
            end

            loadedInstance = instances{1};
            if ~isa(loadedInstance, class(obj))
                error('openMINDS:ControlledTerm:TypeMismatch', ...
                    '"%s" describes a %s, but a %s was asked for.', ...
                    filePath, class(loadedInstance), class(obj))
            end

            for propertyName = string(obj.PropertyNames)
                obj.(propertyName) = loadedInstance.(propertyName);
            end
            obj.id = loadedInstance.id;
        end

        function deserializeFromName(obj, instanceName)

            import openminds.internal.getControlledInstance
            import openminds.internal.utility.getTypeName

            instanceName = char(instanceName);
            schemaName = getTypeName(class(obj));

            if openminds.utility.isIRI(instanceName)
                if openminds.utility.isInstanceIRI(instanceName)
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

                % A term found in the library takes the library's identity.
                % An IRI given by the caller only located it: one from
                % another schema version, or differing in case, names the
                % same instance and must not give it a different
                % identifier. This is the fallback for when the instance
                % file cannot be read; otherwise the file's own @id wins
                % below.
                obj.id = obj.createControlledInstanceIRI(schemaName, instanceName);

                try
                    data = getControlledInstance(instanceName, schemaName, 'controlledTerms');
                catch
                    % Known instance names are sufficient identifiers. The
                    % JSON-LD instance file is only used to enrich metadata.
                    return
                end
            else
                % Deliberately let through: a term a user defined has no
                % library instance to find, and takes its values from the
                % document instead. The identifier is what lets a caller
                % holding only an IRI tell this apart from a term that
                % resolved, without parsing the message.
                warning('openMINDS:ControlledTerm:UnknownInstanceName', ...
                    'No matching instances were found for name "%s".', instanceName)
                return
            end

            propNames = [{'at_id'}, properties(obj)'];
            for i = 1:numel(propNames)
                if isfield(data, propNames{i}) && ~obj.isEmptyValue(data.(propNames{i}))
                    obj.(propNames{i}) = data.(propNames{i});
                end
            end

            if ~obj.isEmptyValue(obj.at_id)
                obj.id = obj.at_id;
            end
        end
    end

    methods (Static, Access = private)
        function instanceIRI = createControlledInstanceIRI(schemaName, instanceName)
            instanceIRI = openminds.constant.BaseIRI + "/instances/" ...
                + openminds.base.ControlledTerm.getInstanceTypeName(schemaName) ...
                + "/" + string(instanceName);
        end

        function typeName = getInstanceTypeName(schemaName)
            typeName = char(schemaName);
            if ~strcmp(upper(typeName(1:2)), typeName(1:2))
                typeName(1) = lower(typeName(1));
            end
            typeName = string(typeName);
        end

        function tf = isLocalFile(instanceSpec)
        % isLocalFile - True when a spec names a JSON-LD document on this machine
        %
        %   isfile resolves a URL over the network, which is slow and
        %   depends on the machine being online, so a URL is ruled out
        %   before the file system is consulted at all.
        %
        %   An extension is required so that the file system cannot decide
        %   what a name means. Without it, a file called "male" in the
        %   working directory would change what ControlledTerm("male")
        %   returns, silently and only on that machine.

            if startsWith(instanceSpec, ["http://", "https://"])
                tf = false;
            else
                tf = endsWith(instanceSpec, [".jsonld", ".json"], 'IgnoreCase', true) ...
                    && isfile(instanceSpec);
            end
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
                ~openminds.base.ControlledTerm.isEmptyValue(structure.(name)), valueFields);
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
