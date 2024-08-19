classdef VocabType < handle

    enumeration
        TYPES("types")
        PROPERTIES("properties")
    end

    properties (SetAccess = immutable)
        Name (1,1) string
        FileName (1,1) string
    end
       
    methods
        function obj = VocabType(name)
            obj.Name = name;
            obj.FileName = name + ".json";
        end
    end
end