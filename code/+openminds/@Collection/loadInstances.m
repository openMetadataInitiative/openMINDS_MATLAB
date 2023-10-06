function instances = loadInstances(filePath)%, options)
%loadInstances Load metadata instances from file(s)

% Todo: 
%   - Add documentation
%   - Test that this works in different cases. Single files, collection of
%     files, 
%   - Generalize to work for multiple file formats.

    arguments
        filePath (1,:) string = ""
        %options.RecursionDepth = 1
    end

    import openminds.internal.serializer.JsonLdSerializer
    import openminds.internal.serializer.jsonld2struct
    
    [~, ~, serializationFormat] = fileparts(filePath(1));

    switch serializationFormat
        case ".jsonld"
            
            %str = fileread(filePath);
            str = arrayfun(@fileread, filePath, 'UniformOutput', false);
            
            %structInstances = jsonld2struct(str);
            if numel(str) == 1
                structInstances = jsonld2struct(str);
            else
                structInstances = cellfun(@jsonld2struct, str, 'UniformOutput', false);
            end
            
            instances = cell(size(structInstances));

            % Create instances...
            for i = 1:numel(structInstances)

                thisInstance = structInstances{i};
                
                openMindsType = thisInstance.at_type;
                className = openminds.internal.utility.string.type2class(openMindsType);

                assert( isequal( eval(sprintf('%s.X_TYPE', className)), openMindsType), ...
                    "Instance type does not match schema type. This is not supposed to happen, please report!")

                instances{i} = feval(className, thisInstance);                
            end
            
            % Link instances / Resolve linked objects...
            for i = 1:numel(instances)
                resolveLinks(instances{i}, instances)
            end

        otherwise
            error('Unkown output format')
    end

    if ~nargout
        clear str
    end
end

function resolveLinks(instance, instanceCollection)
%resolveLinks Resolve linked types, i.e replace an @id with the actual 
% instance object.

    schemaInspector = openminds.internal.SchemaInspector(instance);
    
    instanceIds = cellfun(@(instance) instance.id, instanceCollection, 'UniformOutput', false);

    for i = 1:schemaInspector.NumProperties
        thisPropertyName = schemaInspector.PropertyNames{i};
        if schemaInspector.isPropertyWithLinkedType(thisPropertyName)
            linkedInstances = instance.(thisPropertyName);

            resolvedInstances = cell(size(linkedInstances));

            for j = 1:numel(linkedInstances)
                if isa(linkedInstances(j), 'openminds.internal.abstract.LinkedCategory')
                    try
                        instanceId = linkedInstances(j).Instance.id;
                    catch
                        instanceId = linkedInstances(j).Instance;
                    end
                else
                    instanceId = linkedInstances(j).id;
                end

                isMatchedInstance = strcmp(instanceIds, instanceId);

                if any(isMatchedInstance)
                    resolvedInstances{j} = instanceCollection{isMatchedInstance};
                    resolveLinks(resolvedInstances{j}, instanceCollection)
                end
            end

            try
                resolvedInstances = [resolvedInstances{:}];
            end

            if ~isempty(resolvedInstances)
                instance.(thisPropertyName) = resolvedInstances;
            end
        
        elseif schemaInspector.isPropertyWithEmbeddedType(thisPropertyName)
            embeddedInstances = instance.(thisPropertyName);

            for j = 1:numel(embeddedInstances)
                if isa(embeddedInstances(j), 'openminds.internal.abstract.LinkedCategory')
                    embeddedInstance = embeddedInstances(j).Instance;
                else
                    embeddedInstance = embeddedInstances(j);
                end
                resolveLinks(embeddedInstance, instanceCollection)
            end
        end
    end
end

