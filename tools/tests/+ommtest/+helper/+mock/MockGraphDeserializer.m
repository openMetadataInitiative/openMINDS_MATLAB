classdef MockGraphDeserializer < openminds.base.Deserializer
% MockGraphDeserializer - Reads instances back from mock database records
%
%   Only the record parsing lives here. Type dispatch, instance
%   construction and cross-record link wiring come from
%   openminds.base.Deserializer.

    methods (Access = protected)
        function rawStructs = parseToStructs(~, records)
            rawStructs = cell(1, numel(records));
            for i = 1:numel(records)
                rawStructs{i} = jsondecode(char(records(i).Document));
            end
        end
    end
end
