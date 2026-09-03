function registerLinkResolver(linkResolver, options)
% registerLinkResolver - Register a link resolver in the link resolver registry
%
%   openminds.registerLinkResolver(linkResolver) registers a resolver for
%   the identifier prefix it declares. Registering a prefix that is
%   already registered does nothing, so calling this from library startup
%   code is idempotent.
%
%   openminds.registerLinkResolver(linkResolver, Replace=true) replaces
%   the resolver registered for that prefix with this one. Use this when
%   a library reconfigures, for example connecting to a different server,
%   and needs its new resolver to take effect.
%
%   See also: 
%       openminds.interface.LinkResolver
%       openminds.internal.resolver.InstanceResolver

    arguments
        linkResolver (1,1) {mustBeA(linkResolver, "openminds.interface.LinkResolver")}
        options.Replace (1,1) logical = false
    end

    resolverRegistry = openminds.internal.resolver.LinkResolverRegistry.instance();
    resolverRegistry.addLinkResolver(linkResolver, "Replace", options.Replace);
end
