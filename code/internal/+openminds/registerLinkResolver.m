function registerLinkResolver(linkResolver)
% registerLinkResolver - Register a link resolver in the link resolver registry
    arguments
        linkResolver (1,1) {mustBeA(linkResolver, "openminds.internal.resolver.AbstractLinkResolver")}
    end

    resolverRegistry = openminds.internal.resolver.LinkResolverRegistry.instance();
    resolverRegistry.addLinkResolver(linkResolver);
end
