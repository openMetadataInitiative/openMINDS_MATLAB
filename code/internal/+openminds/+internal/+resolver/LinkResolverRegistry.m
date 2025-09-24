classdef LinkResolverRegistry < handle
% LinkResolverRegistry Singleton registry for LinkResolver instances.
%
    properties (SetAccess = private)
        LinkResolvers (1,:) {mustBeLinkResolverOrEmpty}
    end

    methods (Access = private)
        function obj = LinkResolverRegistry()
            % Private constructor for singleton pattern.
            obj.addLinkResolver(openminds.internal.resolver.InstanceResolver())
        end
    end

    methods
        function addLinkResolver(obj, resolver)
        % Add a resolver instance to the registry (no duplicates by handle).
            arguments
                obj (1,1) openminds.internal.resolver.LinkResolverRegistry
                resolver (1,1) {mustBeA(resolver, "openminds.internal.resolver.AbstractLinkResolver")}
            end

            if any(obj.LinkResolvers == resolver)
                % Already registered
                return
            end

            if ~isempty(obj.LinkResolvers)
                existingIRIPrefixes = [obj.LinkResolvers.IRIPrefix];
                if ismember(resolver.IRIPrefix, existingIRIPrefixes)
                    % Already registered
                    return
                end
            end

            if isempty(obj.LinkResolvers)
                obj.LinkResolvers = resolver;
            else
                obj.LinkResolvers(end+1) = resolver;
            end
        end

        function resolver = getLinkResolver(obj, IRI)
        % Return the first registered resolver that can handle IRI.
        % Throws if none found.
            arguments
                obj (1,1) openminds.internal.resolver.LinkResolverRegistry
                IRI (1,:) string
            end

            resolver = [];
            for r = obj.LinkResolvers
                if r.canResolve(IRI(1)) % Assume all IRIs can be resolved by the same resolver
                    resolver = r;
                    obj.promoteResolver(r)
                    break
                end
            end

            if isempty(resolver)
                error('openMINDS_MATLAB:LinkResolverRegistry:NotFound', ...
                    'No resolver registered that can handle IRI: %s', IRI);
            end
        end

        function tf = hasLinkResolver(obj, name)
            tf = any( arrayfun(@(x) isa(x, name), obj.LinkResolvers));
        end
    
        function reset(obj)
            obj.LinkResolvers = [];
            % Add the default resolver
            obj.addLinkResolver(openminds.internal.resolver.InstanceResolver())
        end
    end

    methods (Access = private)
        function promoteResolver(obj, resolver)
        % moveResolverToFront - Reorder registry so resolver is first.
            arguments
                obj (1,1) openminds.internal.resolver.LinkResolverRegistry
                resolver (1,1) {mustBeA(resolver, "openminds.internal.resolver.AbstractLinkResolver")}
            end
    
            % Find resolver index
            idx = find(arrayfun(@(x) isequal(x, resolver), obj.LinkResolvers));

            if isempty(idx)
                error('LinkResolverRegistry:ResolverNotFound', ...
                    'Resolver is not registered in this registry.');
            end
    
            if idx == 1
                return % Already at front
            end
    
            % Reorder: put this resolver first, keep relative order of others
            obj.LinkResolvers = [obj.LinkResolvers(idx), ...
                                 obj.LinkResolvers([1:idx-1, idx+1:end])];
        end
    end

    methods (Static)
        function obj = instance()
            % Singleton accessor.
            persistent singletonInstance
            if isempty(singletonInstance) || ~isvalid(singletonInstance)
                singletonInstance = openminds.internal.resolver.LinkResolverRegistry();
            end
            obj = singletonInstance;
        end
    end
end

function mustBeLinkResolverOrEmpty(value)
% This special validator is necessary for object construction, because it
% is not possible to create an empty object of an abstract class and as we
% want to ensure the values of the LinkResolvers is an implementation of
% the AbstractLinkResolver we also need to allow empty values.
    if ~isempty(value)
        actualType = arrayfun(@class, value, 'UniformOutput', false);
        assert(...
            isa(value, "openminds.internal.resolver.AbstractLinkResolver"), ...
            'openMINDS_MATLAB:LinkResolverRegistry:InvalidLinkResolver', ...
            ['LinkResolver must be a concrete implementation ', ...
            'AbstractLinkResolver. Got %s instead'], strjoin(actualType, ', '))
    end
end