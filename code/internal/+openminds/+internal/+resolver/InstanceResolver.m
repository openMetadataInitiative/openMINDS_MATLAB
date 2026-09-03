classdef InstanceResolver < openminds.interface.LinkResolver
% InstanceResolver - Resolves openMINDS controlled instances from the local library

    properties (Constant)
        IRIPrefix = openminds.constant.BaseURI("v1") + "/instances" % Todo: get from constant
    end

    methods
        function instance = resolveNode(~, instance)
            arguments
                ~
                instance (1,1) openminds.abstract.Schema
            end

            [typeEnum, instanceName] = openminds.utility.parseInstanceIRI(instance.id);
            instances = openminds.internal.listControlledInstances(typeEnum);

            isMatch = instances.InstanceName == string(instanceName);
            if ~any(isMatch)
                error('openMINDS:LinkResolver:InstanceNotFound', ...
                    'Could not find data for instance with IRI "%s"', instance.id)
            end

            % Todo: use the JSON-LD deserializer once it exists
            data = jsondecode(fileread(instances.Filepath(isMatch)));
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
