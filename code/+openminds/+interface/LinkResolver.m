classdef (Abstract) LinkResolver < handle
% LinkResolver - Turns a reference node into a populated instance
%
%   A resolver knows how to fetch the data behind one kind of identifier.
%   It does not walk the graph: traversal, link depth and cycle detection
%   belong to the toolbox, which selects a resolver for each reference it
%   meets. That separation matters because one graph can hold references
%   from several sources, and no single resolver can handle all of them.
%
%   Concrete implementations must provide:
%       - IRIPrefix   A constant naming the resolver in the registry,
%                     which keeps at most one resolver per prefix. It is
%                     not consulted when matching an identifier; that is
%                     what canResolve is for.
%       - canResolve  Whether it can handle one given identifier
%       - resolveNode Fetch or populate a single reference node
%
%   RESOLVING IN PLACE OR BY REPLACEMENT:
%   -------------------------------------
%   resolveNode returns the resolved instance, and callers must use the
%   returned value rather than assuming the argument was modified.
%
%   A reference whose type is known can be populated in place, and
%   returning it unchanged is correct. A reference whose type is not known
%   until it is probed cannot be, because an instance cannot change its
%   class: the resolver has to build an instance of the discovered type
%   and return that instead. Both are legitimate, and which one applies is
%   a property of the reference rather than of the resolver. Ask
%   isTypeKnown which case you are in. A replacement must carry the
%   identifier of the reference it replaces, since every link to the node
%   is written with that identifier; the toolbox errors when it does not.
%
%   See also openminds.registerLinkResolver, openminds.Node

    properties (Constant, Abstract)
        IRIPrefix (1,1) string
    end

    methods (Abstract)
        instance = resolveNode(obj, instance)
        % resolveNode - Fetch or populate a single reference node

        tf = canResolve(obj, IRI)
        % canResolve - Whether this resolver handles the given identifier
        %
        %   IRI is one identifier, a scalar string, and tf a scalar logical.
    end

    methods (Static)
        function tf = isTypeKnown(instance)
        % isTypeKnown - Whether a reference already knows its type
        %
        %   Syntax:
        %       tf = openminds.interface.LinkResolver.isTypeKnown(instance)
        %
        %   Description:
        %       Answers the question resolveNode has to answer first: a
        %       reference whose type is known can be populated in place and
        %       returned unchanged, while one whose type is not known has to
        %       be replaced by a new instance of the discovered type, since
        %       an instance cannot change its class.
        %
        %   Input Arguments:
        %       instance - The reference node passed to resolveNode.
        %
        %   Output Arguments:
        %       tf - true when the reference is already of the target type.
        %
        %   Example:
        %       function instance = resolveNode(obj, instance)
        %           data = obj.fetch(instance.id);
        %           if openminds.interface.LinkResolver.isTypeKnown(instance)
        %               instance.set(data);
        %           else
        %               instance = openminds.fromTypeName(data.type, instance.id);
        %               instance.set(data);
        %           end
        %       end
            arguments
                instance (1,1) openminds.Node
            end
            tf = ~isa(instance, "openminds.internal.MixedTypeReference");
        end
    end
end
