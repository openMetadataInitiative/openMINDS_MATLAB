classdef MockGraphSerializer < openminds.base.Serializer
% MockGraphSerializer - Serializes instances into mock database records
%
%   A non-JSON-LD output format built on the shared serialization core:
%   graph traversal, reference handling and embedding come from
%   openminds.base.Serializer; only the record format is here.

    properties (Constant)
        DefaultFileExtension = ".mockrecord"
    end

    methods
        function obj = MockGraphSerializer(config)
            arguments
                config.?openminds.internal.serializer.SerializationConfig
            end
            config.OutputMode = "multiple"; % one record per node
            nvPairs = namedargs2cell(config);
            obj = obj@openminds.base.Serializer(nvPairs{:});
        end
    end

    methods (Access = protected)
        function records = formatOutput(~, processedStructs)
            records = cell(1, numel(processedStructs));
            for i = 1:numel(processedStructs)
                S = processedStructs{i};
                records{i} = struct( ...
                    'Identifier', string(S.at_id), ...
                    'TypeIRI', string(S.at_type), ...
                    'Document', string(jsonencode(S)));
            end
            records = [records{:}];
        end
    end
end
