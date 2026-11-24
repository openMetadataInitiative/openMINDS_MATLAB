classdef UntypedLinkNodeFixture < openminds.Node
%UntypedLinkNodeFixture A node whose linked property accepts any type
%
%   Exists only to exercise indexing across an array of nodes. Every
%   generated type declares the class of each linked property, so an array
%   of one type cannot hold values of different classes in that property.
%   This fixture leaves the class open so a test can build that case.

    properties
        link (1,:)
    end

    properties (Access = protected)
        Required = string.empty
    end

    properties (Constant, Hidden)
        X_TYPE = "https://example.org/types/UntypedLinkNodeFixture"
        LINKED_PROPERTIES = struct('link', "openminds.Node")
        EMBEDDED_PROPERTIES = struct()
    end

    methods
        function obj = UntypedLinkNodeFixture(propValues)
            arguments
                propValues.link
            end
            nvPairs = namedargs2cell(propValues);
            obj@openminds.Node(struct.empty, nvPairs{:})
        end
    end

    methods (Access = protected)
        function str = getDisplayLabel(~)
            str = "untyped link node";
        end
    end
end
