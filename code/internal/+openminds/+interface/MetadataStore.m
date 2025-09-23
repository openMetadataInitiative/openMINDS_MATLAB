classdef (Abstract) MetadataStore < matlab.mixin.SetGet
% MetadataStore - Abstract interface for metadata storage implementations
%
%   This abstract class defines the common interface for all metadata store
%   implementations. Different store types may have different signatures
%   and requirements based on their storage paradigm:
%
%   - KG Stores: Work with individual instances, save to remote Knowledge Graph
%   - File Stores: Work with collections, save to local files/folders
%   - Database Stores: Work with collections, save to databases
%
%   ABSTRACT METHODS (must be implemented by subclasses):
%   --------------------------------------------------------
%
%   save(obj, instances, varargin) - Save openMINDS instances to the store
%   load(obj, varargin) - Load openMINDS instances from the store
%
%   Each implementation defines its own method signatures and behavior
%   appropriate for its storage paradigm.
    
    properties (SetAccess = protected)
        Serializer
    end
    
    methods
        function obj = MetadataStore()
            % Base constructor - concrete implementations handle their own setup
        end
    end

    methods (Abstract)
        result = save(obj, instances, varargin)
        instances = load(obj, varargin)
    end
end
