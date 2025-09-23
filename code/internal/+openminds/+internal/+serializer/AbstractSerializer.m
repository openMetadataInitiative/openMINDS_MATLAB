classdef AbstractSerializer < handle

    properties
    end

    methods (Abstract)
        result = serialize(obj, instances, options)
        instances = deserialize(obj, data, options)
    end
end
