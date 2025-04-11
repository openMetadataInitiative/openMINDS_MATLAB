function instances = loadInstances(filePath)%, options)
%loadInstances Load metadata instances from file(s)

% Todo:
%   - Add documentation
%   - Test that this works in different cases. Single files, collection of
%     files,
%   - Generalize to work for multiple file formats.

    arguments
        filePath (1,:) string = ""
        % options.RecursionDepth = 1
    end

    import openminds.internal.serializer.JsonLdSerializer
    import openminds.internal.serializer.jsonld2struct
    
    [~, ~, serializationFormat] = fileparts(filePath(1));

    switch serializationFormat
        case ".jsonld"
            
            % Read one or more files
            str = arrayfun(@fileread, filePath, 'UniformOutput', false);
            
            % Produce a cell array of instances represented as structs
            if numel(str) == 1
                structInstances = jsonld2struct(str);
                if ~iscell(structInstances); structInstances={structInstances};end
            else
                structInstances = cellfun(@jsonld2struct, str, 'UniformOutput', false);
            end
            
            % Create instance objects
            instances = cell(size(structInstances));
            for i = 1:numel(structInstances)

                thisInstance = structInstances{i};

                if ~isfield(thisInstance, 'at_type')
                    continue % Todo: Why skip?
                    % instances{i} = struct('id', thisInstance.at_id);
                else
                    openMindsType = thisInstance.at_type;
                    className = openminds.internal.utility.string.type2class(openMindsType);
    
                    assert( isequal( eval(sprintf('%s.X_TYPE', className)), openMindsType), ...
                        "Instance type does not match schema type. This is not supposed to happen, please report!")
    
                    try
                        instances{i} = feval(className, thisInstance);
                    catch ME
                        warning(ME.message)
                    end
                end
            end

            isEmpty = cellfun(@(c) isempty(c), instances);
            instances(isEmpty) = [];

            instanceIds = cellfun(@(instance) instance.id, instances, 'UniformOutput', false);
            instanceIds = string(instanceIds);
            
            % Link instances / Resolve linked objects...
            for i = 1:numel(instances)
                resolveLinks(instances{i}, instanceIds, instances)
            end

        otherwise
            error('Unkown input format')
    end

    if ~nargout
        clear str
    end
end

function resolveLinks(instance, instanceIds, instanceCollection)
%resolveLinks Resolve linked types, i.e replace an @id with the actual
% instance object.

    if isstruct(instance) % Instance is not resolvable (E.g belongs to remote collection)
        return
    end

    persistent schemaInspectorMap
    if isempty(schemaInspectorMap)
        schemaInspectorMap = dictionary;
    end

    instanceType = class(instance);
    if ~isConfigured(schemaInspectorMap) || ~isKey(schemaInspectorMap, instanceType)
        schemaInspectorMap(instanceType) = openminds.internal.SchemaInspector(instance);
    end

    schemaInspector = schemaInspectorMap(instanceType);
    
    for i = 1:schemaInspector.NumProperties
        thisPropertyName = schemaInspector.PropertyNames{i};
        if schemaInspector.isPropertyWithLinkedType(thisPropertyName)
            linkedInstances = instance.(thisPropertyName);

            resolvedInstances = cell(size(linkedInstances));

            for j = 1:numel(linkedInstances)
                if openminds.utility.isMixedInstance(linkedInstances(j))
                    try
                        instanceId = linkedInstances(j).Instance.id;
                    catch
                        instanceId = linkedInstances(j).Instance;
                    end
                else
                    instanceId = linkedInstances(j).id;
                end

                isMatchedInstance = instanceIds == string(instanceId);

                if any(isMatchedInstance)
                    resolvedInstances{j} = instanceCollection{isMatchedInstance};
                    resolveLinks(resolvedInstances{j}, instanceIds, instanceCollection)
                else
                    % Check if instance is a controlled instance
                    if startsWith(instanceId, "https://openminds.ebrains.eu/instances/")
                        resolvedInstances{j} = openminds.instanceFromIRI(instanceId);
                    end
                end
            end

            try
                resolvedInstances = [resolvedInstances{:}];
            catch
                assert(isa(resolvedInstances, 'cell'), ...
                    'Expected resolved instances to be a cell array')
            end

            if ~isempty(resolvedInstances)
                instance.(thisPropertyName) = resolvedInstances;
            end
        
        elseif schemaInspector.isPropertyWithEmbeddedType(thisPropertyName)
            embeddedInstances = instance.(thisPropertyName);

            for j = 1:numel(embeddedInstances)
                if openminds.utility.isMixedInstance(embeddedInstances(j))
                    embeddedInstance = embeddedInstances(j).Instance;
                else
                    embeddedInstance = embeddedInstances(j);
                end
                resolveLinks(embeddedInstance, instanceIds, instanceCollection)
            end
        end
    end
end
