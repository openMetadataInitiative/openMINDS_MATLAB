function registerLinkResolver(linkResolver)
% registerLinkResolver - Register a link resolver in the link resolver registry
%
%   See also: 
%       openminds.internal.resolver.AbstractLinkResolver
%       openminds.internal.resolver.InstanceResolver

    arguments
        linkResolver (1,1) {mustBeA(linkResolver, "openminds.internal.resolver.AbstractLinkResolver")}
    end

    resolverRegistry = openminds.internal.resolver.LinkResolverRegistry.instance();
    resolverRegistry.addLinkResolver(linkResolver);
end
