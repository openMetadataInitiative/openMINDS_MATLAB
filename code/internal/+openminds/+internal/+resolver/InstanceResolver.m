classdef InstanceResolver < openminds.interface.LinkResolver
% InstanceResolver - Resolves openMINDS controlled instances from the local library

    properties (Constant)
        IRIPrefix = openminds.constant.BaseURI("v1") + "/instances" % Todo: get from constant
    end

    methods
        function instance = resolveNode(~, instance)
            arguments
                ~
                instance (1,1) openminds.Node
            end

            [typeEnum, instanceName] = openminds.utility.parseInstanceIRI(instance.id);
            instances = openminds.internal.listControlledInstances(typeEnum);

            isMatch = instances.InstanceName == string(instanceName);
            if ~any(isMatch)
                error('openMINDS:LinkResolver:InstanceNotFound', ...
                    'Could not find data for instance with IRI "%s"', instance.id)
            end

            % Decode through the shared JSON-LD utility, so the struct
            % carries at_-form keywords like every other decoded document.
            % Raw jsondecode would mangle @id into x_id.
            data = openminds.internal.utility.json.decode( ...
                fileread(instances.Filepath(isMatch)));
            instance.fromStruct(data);
        end

        function tf = canResolve(~, IRI)
        % canResolve - Check whether this resolver can resolve an IRI
            arguments
                ~
                IRI (1,1) string
            end
            tf = startsWith(IRI, openminds.constant.BaseURI("v1") + "/instances") || ...
                startsWith(IRI, openminds.constant.BaseURI("v4") + "/instances");
        end
    end
end
