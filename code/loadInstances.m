function instances = loadInstances(filePath, options)
    
    arguments
        filePath (1,1) string = ""
        options.OutputFormat (1,1) string = "jsonld"
        %options.RecursionDepth = 1
    end

    import openminds.internal.serializer.JsonLdSerializer
    
    switch options.OutputFormat
        case "jsonld"

            str = fileread(filePath);
            structInstances = openminds.internal.serializer.jsonld2struct(str);
            
            instances = cell(size(structInstances));

            % Create instances...
            for i = 1:numel(structInstances)

                thisInstance = structInstances{i};
                
                openMindsType = thisInstance.at_type{1};
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
                resolvedInstances{j} = instanceCollection{isMatchedInstance};
            
                resolveLinks(resolvedInstances{j}, instanceCollection)
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

