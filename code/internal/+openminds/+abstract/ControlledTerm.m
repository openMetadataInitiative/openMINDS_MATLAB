classdef (Abstract) ControlledTerm < openminds.abstract.Schema
%ControlledTerm Abstract base class for metadata types of the controlled terms module

    properties (Access = protected)
        Required = {'name'}
    end
    
    properties
        % Enter one sentence for defining this term.
        definition (1,1) string

        % Enter a short text describing this term.
        description (1,1) string

        % Enter the internationalized resource identifier (IRI) pointing to the integrated ontology entry in the InterLex project.
        interlexIdentifier (1,1) string

        % Enter the internationalized resource identifier (IRI) pointing to the wiki page of the corresponding term in the KnowledgeSpace.
        knowledgeSpaceLink (1,1) string

        % Controlled term originating from a defined terminology.
        name (1,1) string

        % Enter the internationalized resource identifier (IRI) pointing to the preferred ontological term.
        preferredOntologyIdentifier (1,1) string

        % Enter one or several synonyms (including abbreviations) for this controlled term.
        synonym (1,:) string {mustBeListOfUniqueItems(synonym)}
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

    methods
        function obj = ControlledTerm(instanceSpec, propValues)
            
            arguments
                instanceSpec = []
                propValues.?openminds.abstract.ControlledTerm
                propValues.id (1,1) string
            end

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
                        obj.load( instanceSpec ) % todo: Not implemented??
                    else
                        % Deserialize from name of controlled instance
                        obj.deserializeFromName(instanceSpec);
                    end
                elseif isstruct( instanceSpec ) && isfield(instanceSpec, 'at_id') || isfield(instanceSpec, 'x_id')
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
                        'Expected instance spec to be a name, a filename or a structure with `at_id` field.')
                end

                names = fieldnames(propValues);
                obj.warnIfPropValuesSupplied(names)
            else
                obj.set(propValues)
                if ismissing(obj.id)
                    obj.id = obj.generateInstanceId();
                end
            end
        end
    end
    
    methods (Access = protected) % Implement method for the CustomInstanceDisplay mixin
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
            schemaName = getSchemaName(class(obj));

            if openminds.utility.isIRI(instanceName)
                if openminds.utility.isInstanceIRI(instanceName)
                     [~, instanceName] = openminds.utility.parseInstanceIRI(instanceName);
                else
                    obj.id = instanceName;
                    return
                end
            end
            
            [instanceName, instanceNameOrig] = deal(instanceName);
            if ~any(strcmp(obj.CONTROLLED_INSTANCES, instanceName))
                % Try to make a valid name
                instanceName = strrep(instanceName, ' ', '');
                instanceName = matlab.lang.makeValidName(instanceName, 'ReplacementStyle', 'delete');
            end

            % Todo: Use a proper deserializer
            if any(strcmpi(obj.CONTROLLED_INSTANCES, instanceName))
                try
                    data = getControlledInstance(instanceName, schemaName, 'controlledTerms');
                catch
                    s = warning('off', 'backtrace');
                    warningCleanup = onCleanup(@() warning(s));
                    warning('Controlled instance "%s" is not available.', instanceNameOrig)
                    return
                end
            else
                warning('No matching instances were found for name "%s"', instanceName)
                return
                % error('Deserialization from user instance is not implemented yet')
            end
            propNames = {'at_id', 'name', 'definition', 'description', 'interlexIdentifier', 'knowledgeSpaceLink', 'preferredOntologyIdentifier', 'synonym'};

            for i = 1:numel(propNames)
                if ~isempty( data.(propNames{i}) )
                    obj.(propNames{i}) = data.(propNames{i});
                end
            end

            obj.id = obj.at_id;
        end
    end
end
