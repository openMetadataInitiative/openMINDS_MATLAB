classdef MockGraphDatabase < handle
% MockGraphDatabase - Stands for an external graph database, in memory
%
%   Records are structs with fields Identifier, TypeIRI and Document,
%   where Document is the node as JSON text with MATLAB-shim field names.

    properties (Access = private)
        Records
    end

    methods
        function obj = MockGraphDatabase()
            obj.Records = containers.Map('KeyType', 'char', 'ValueType', 'any');
        end

        function put(obj, record)
            obj.Records(char(record.Identifier)) = record;
        end

        function record = get(obj, identifier)
            record = obj.Records(char(identifier));
        end

        function records = all(obj)
            values = obj.Records.values;
            records = [values{:}];
        end

        function n = count(obj)
            n = obj.Records.Count;
        end
    end
end
