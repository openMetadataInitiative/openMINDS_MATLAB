classdef LinkResolverRegistry < handle
% LinkResolverRegistry Singleton registry for LinkResolver instances.
%
    properties (SetAccess = private)
        % Registered resolvers in lookup order. Each implements the link
        % resolver interface; nothing else is assumed about them.
        LinkResolvers (1,:) cell = {}
    end

    methods (Access = private)
        function obj = LinkResolverRegistry()
            % Private constructor for singleton pattern.
            obj.addLinkResolver(openminds.internal.resolver.InstanceResolver())
        end
    end

    methods
        function addLinkResolver(obj, resolver, options)
        % Add a resolver to the registry, at most one per IRI prefix.
        %
        %   By default a resolver whose prefix is already registered is
        %   ignored, so registering at startup is idempotent. Pass
        %   Replace=true to swap the registered resolver for this one,
        %   keeping its position: a library that reconfigures, for example
        %   with a new server or credentials, re-registers rather than
        %   mutating the resolver it registered earlier.
            arguments
                obj (1,1) openminds.internal.resolver.LinkResolverRegistry
                resolver (1,1) {mustBeA(resolver, "openminds.interface.LinkResolver")}
                options.Replace (1,1) logical = false
            end

            existingIndex = obj.indexOfPrefix(resolver.IRIPrefix);

            if isempty(existingIndex)
                obj.LinkResolvers{end+1} = resolver;
            elseif options.Replace
                obj.LinkResolvers{existingIndex} = resolver;
            end
            % Otherwise already registered; keep the existing resolver.
        end

        function tf = hasResolverForPrefix(obj, iriPrefix)
            tf = ~isempty( obj.indexOfPrefix(iriPrefix) );
        end

        function resolver = getLinkResolver(obj, IRI)
        % Return the first registered resolver that can handle IRI.
        % Throws if none found.
            arguments
                obj (1,1) openminds.internal.resolver.LinkResolverRegistry
                IRI (1,1) string
            end

            resolver = [];
            for i = 1:numel(obj.LinkResolvers)
                candidate = obj.LinkResolvers{i};
                if candidate.canResolve(IRI)
                    resolver = candidate;
                    obj.promoteResolver(i)
                    break
                end
            end

            if isempty(resolver)
                error('openMINDS_MATLAB:LinkResolverRegistry:NotFound', ...
                    'No resolver registered that can handle IRI: %s', IRI);
            end
        end

        function tf = hasLinkResolver(obj, name)
            tf = any( cellfun(@(r) isa(r, name), obj.LinkResolvers) );
        end
    
        function reset(obj)
            obj.LinkResolvers = {};
            % Add the default resolver
            obj.addLinkResolver(openminds.internal.resolver.InstanceResolver())
        end
    end

    methods (Access = private)
        function index = indexOfPrefix(obj, iriPrefix)
        % Position of the resolver registered for a prefix, or empty.
            index = find( cellfun(@(r) r.IRIPrefix == iriPrefix, obj.LinkResolvers), 1 );
        end

        function promoteResolver(obj, index)
        % promoteResolver - Reorder registry so the resolver at index is first
            arguments
                obj (1,1) openminds.internal.resolver.LinkResolverRegistry
                index (1,1) double {mustBePositive, mustBeInteger}
            end

            if index == 1
                return % Already at front
            end

            % Keep the relative order of the remaining resolvers
            obj.LinkResolvers = [obj.LinkResolvers(index), ...
                                 obj.LinkResolvers([1:index-1, index+1:end])];
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
