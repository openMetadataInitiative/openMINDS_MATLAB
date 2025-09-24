function resolver = getLinkResolver(IRI)
% getLinkResolver - Get a link resolver that can resolve given IRI
    arguments
        IRI (1,:) string
    end
    resolverRegistry = openminds.internal.resolver.LinkResolverRegistry.instance();
    resolver = resolverRegistry.getLinkResolver(IRI);
end
