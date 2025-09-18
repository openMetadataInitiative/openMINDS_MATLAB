classdef InstanceResolver < openminds.internal.resolver.AbstractLinkResolver

    properties (Constant)
        IRIPrefix = openminds.constant.BaseURI("v1") + "/instances" % Todo: get from constant
    end

    methods (Static)
        function instance = resolve(instance, options)
            arguments
                instance (1,1) openminds.abstract.Schema % todo: support array
                options.NumLinksToResolve = 0 %#ok<INUSA> %TODO
            end
            [typeEnum, instanceName] = openminds.utility.parseInstanceIRI(instance.id);
            instances = openminds.internal.listControlledInstances(typeEnum);
            isMatch = instances.InstanceName==string(instanceName);
            if any(isMatch)
                data = jsondecode(fileread(instances.Filepath(isMatch)));
            else
                error(['Could not find data for instance with IRI ', ...
                    '"%s"'], instance.id)
            end
            instance.fromStruct(data);
        end

        function tf = canResolve(IRI)
            arguments
                IRI (1,:) string
            end
            tf = startsWith(IRI, openminds.constant.BaseURI("v1") + "/instances") || ...
                startsWith(IRI, openminds.constant.BaseURI("v4") + "/instances");
        end
    end
end
