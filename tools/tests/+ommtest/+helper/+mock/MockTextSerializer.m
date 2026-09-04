classdef MockTextSerializer < openminds.base.Serializer
% MockTextSerializer - Serializes instances into a plain, non-JSON-LD text format
%
%   Stands for an external, non-JSON-LD serializer, such as one written
%   against a Knowledge Graph's own document format. Unlike
%   MockGraphSerializer, whose struct records are for a database-backed
%   store, this emits text, so it can be plugged into a text-file-based
%   store such as FolderMetadataStore.

    properties (Constant)
        DefaultFileExtension = ".mocktext"
    end

    methods
        function obj = MockTextSerializer(config)
            arguments
                config.?openminds.internal.serializer.SerializationConfig
            end
            config.OutputMode = "multiple"; % one document per node
            nvPairs = namedargs2cell(config);
            obj = obj@openminds.base.Serializer(nvPairs{:});
        end
    end

    methods (Access = protected)
        function texts = formatOutput(~, processedStructs)
            texts = cell(1, numel(processedStructs));
            for i = 1:numel(processedStructs)
                S = processedStructs{i};
                if isfield(S, 'at_id')
                    idLine = sprintf('id: %s\n', string(S.at_id));
                else
                    idLine = '';
                end
                texts{i} = sprintf('type: %s\n%s', string(S.at_type), idLine);
            end
        end
    end
end
