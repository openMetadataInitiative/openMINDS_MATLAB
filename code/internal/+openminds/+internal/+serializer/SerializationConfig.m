classdef SerializationConfig < matlab.mixin.SetGet
%SerializationConfig Configuration class for openMINDS serialization operations
%
%   This class provides a centralized way to configure serialization
%   behavior for openMINDS metadata instances.
%
%   USAGE:
%   ------
%   config = SerializationConfig() % Default configuration
%   
%   config = SerializationConfig( ...
%       'RecursionDepth', 2, ...
%       'WithContext', true, ...
%       'IncludeEmptyProperties', false)
%
%   PROPERTIES:
%   -----------
%   RecursionDepth           - Maximum recursion depth for linked types
%   WithContext              - Include @context in JSON-LD output
%   IncludeEmptyProperties   - Include properties with empty values
%   UseSemanticPropertyName  - Use semantic property names with vocab URI
%   IncludeIdentifier        - Include @id in serialized output
%   EnableCaching            - Enable instance caching for performance
%   EnableValidation         - Enable validation during serialization
%   OutputEncoding           - Character encoding for output files
%   PrettyPrint              - Format output for human readability

    properties
        % Core serialization options
        RecursionDepth (1,1) {mustBeInteger, mustBeNonnegative} = 1
        
        % JSON-LD specific options
        WithContext (1,1) logical = false
        UseSemanticPropertyName (1,1) logical = false
        
        % Content options
        IncludeIdentifier (1,1) logical = true
        IncludeEmptyProperties (1,1) logical = false
        
        % Performance options
        EnableCaching (1,1) logical = true
        
        % Quality options
        EnableValidation (1,1) logical = true
        
        % Output formatting options
        OutputEncoding (1,1) string {mustBeMember(OutputEncoding, ["UTF-8", "UTF-16", "ASCII"])} = "UTF-8"
        PrettyPrint (1,1) logical = true

        OutputMode (1,1) string {mustBeMember(OutputMode, ["single", "multiple"])} = "single"
        % Todo: File export
        % Save to single, save to multiple
        % Filename / root foldername
        % Folder flat | nested
    end

    methods
        function obj = SerializationConfig(options)
        %SerializationConfig Constructor for serialization configuration
        %
        %   config = SerializationConfig() creates default configuration
        %
        %   config = SerializationConfig(Name, Value, ...) creates 
        %   configuration with specified options
        %
        %   PARAMETERS:
        %   -----------
        %   RecursionDepth : integer (default: 1)
        %       Maximum depth for recursively serializing linked types.
        %       0 = no recursion, only references
        %
        %   WithContext : logical (default: true)
        %       Include @context property in JSON-LD output
        %
        %   UseSemanticPropertyName : logical (default: false)
        %       Use full semantic property names with vocabulary URI
        %
        %   IncludeIdentifier : logical (default: true)
        %       Include @id property in serialized instances
        %       
        %   IncludeEmptyProperties : logical (default: false)
        %       Include properties that have empty values
        %
        %   EnableCaching : logical (default: true)
        %       Enable caching of serialized instances for performance
        %
        %   EnableValidation : logical (default: true)
        %       Enable validation during serialization process
        %
        %   OutputEncoding : string (default: "UTF-8")
        %       Character encoding for output files
        %
        %   PrettyPrint : logical (default: true)
        %       Format output for human readability
            
            arguments
                options.?openminds.internal.serializer.SerializationConfig
            end
            
            obj.set(options)
        end

        function updateFromNameValuePairs(obj, propValues)
            arguments
                obj (1,1) openminds.internal.serializer.SerializationConfig
                propValues.?openminds.internal.serializer.SerializationConfig
            end
            
            obj.set(propValues)
        end

        function updateFromStructure(obj, structure)
            arguments
                obj (1,1) openminds.internal.serializer.SerializationConfig
                structure (1,1) struct
            end
            obj.set(structure)
        end
    end
end
