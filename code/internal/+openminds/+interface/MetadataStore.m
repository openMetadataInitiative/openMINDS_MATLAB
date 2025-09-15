classdef MetadataStore < matlab.mixin.SetGet % Todo: visitor pattern
% MetadataStore - Abstract pattern for a MetadataStore class
%
%   This class defines an abstract pattern for a class that can "visit" an
%   instance via its `save` method, in accordance with the Visitor design
%   pattern: https://refactoring.guru/design-patterns/visitor
%
%   Concrete implementations must implement these methods
%       - save - Save an instance or a set of instances
    
    properties (SetAccess = protected)
        Serializer 
    end
    
    methods
        function obj = MetadataStore()
        end
    end

    methods (Abstract)
        storedIdentifier = save(instances)
    end
end

