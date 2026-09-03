classdef JsonLdDeserializer < openminds.internal.serializer.BaseDeserializer
% JsonLdDeserializer - Reads openMINDS instances from JSON-LD
%
%   The counterpart to JsonLdSerializer. Accepts either a single document
%   or several, and both a document holding one instance and a collection
%   document holding an @graph.
%
%   USAGE:
%   ------
%   deserializer = openminds.internal.serializer.JsonLdDeserializer();
%   instances = deserializer.deserialize(jsonText);
%
%   See also openminds.internal.serializer.JsonLdSerializer

    properties (Constant)
        DefaultFileExtension = ".jsonld"
    end

    methods
        function obj = JsonLdDeserializer(options)
            arguments
                options.UnreadableNodePolicy (1,1) string ...
                    {mustBeMember(options.UnreadableNodePolicy, ["warning", "error"])} = "warning"
            end
            obj.UnreadableNodePolicy = options.UnreadableNodePolicy;
        end
    end

    methods (Access = protected)
        function rawStructs = parseToStructs(~, data)
        % parseToStructs - Decode one or more JSON-LD documents

            arguments
                ~
                data (1,:) string
            end

            rawStructs = {};

            for i = 1:numel(data)
                decoded = openminds.internal.serializer.jsonld2struct(data(i));

                if ~iscell(decoded)
                    decoded = num2cell(decoded);
                end

                rawStructs = [rawStructs, reshape(decoded, 1, [])]; %#ok<AGROW>
            end
        end
    end
end
