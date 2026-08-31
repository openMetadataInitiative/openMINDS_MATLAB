function registerLinkResolver(linkResolver)
% registerLinkResolver - Register a link resolver in the link resolver registry
%
%   See also: 
%       openminds.interface.LinkResolver
%       openminds.internal.resolver.InstanceResolver

    arguments
        linkResolver (1,1) {mustBeA(linkResolver, "openminds.interface.LinkResolver")}
    end

    resolverRegistry = openminds.internal.resolver.LinkResolverRegistry.instance();
    resolverRegistry.addLinkResolver(linkResolver);
end
