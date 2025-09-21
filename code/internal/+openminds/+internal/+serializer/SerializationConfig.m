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
%       'IncludeEmptyProperties', false)
%
%   PROPERTIES:
%   -----------
%   RecursionDepth           - Maximum recursion depth for linked types          Serialization option, not serializer 

%   PropertyNameSyntax       - Whether to use expanded or compact syntax for property names       Json-ld serializer 
%   PrettyPrint              - Format output for human readability               Json-ld  

%   IncludeIdentifier        - Include @id in serialized output
%   IncludeEmptyProperties   - Include properties with empty values              

%   EnableCaching            - Enable instance caching for performance
%   EnableValidation         - Enable validation during serialization
%   OutputEncoding           - Character encoding for output files


% Some notes:
%   This serialiser is not a general json-ld serialiser, but simplified to
%   work with openminds metadata. 
%      - When using vocabulary mapping, we assume all properties live in
%        the same namespace (i.e the openMINDS namespace) 
% 

    properties
        % Core serialization options
        RecursionDepth (1,1) {mustBeInteger, mustBeNonnegative} = 1
        
        % JSON-LD specific options
        % PropertyNameSyntax - Whether to use expanded or compact syntax
        % for property names
        PropertyNameSyntax (1,1) string {mustBeMember(PropertyNameSyntax, ["compact","expanded"])} = "compact"

        % Content options
        IncludeIdentifier (1,1) logical = true
        IncludeEmptyProperties (1,1) logical = false
        
        % Performance options
        EnableCaching (1,1) logical = true
        
        % Quality options
        EnableValidation (1,1) logical = true
        
        % Output formatting options (Text only serialisation)
        OutputEncoding (1,1) string {mustBeMember(OutputEncoding, ["UTF-8", "UTF-16", "ASCII"])} = "UTF-8"
        PrettyPrint (1,1) logical = true
        
        % OutputMode : Whether to output all metadata in a single document
        % or in multiple documents
        OutputMode (1,1) string {mustBeMember(OutputMode, ["single", "multiple"])} = "multiple" % single document / multiple documents
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
        %   PropertyNameSyntax : string (default: compact)
        %       Use full semantic property names with vocabulary URI (expanded) 
        %       or add vocabulary mapping in document context (compact).
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

    methods (Static)
        function obj = fromStruct(structure)
            arguments
                structure (1,1) struct
            end
            obj = openminds.internal.serializer.SerializationConfig();
            obj.updateFromStructure(structure)
        end
    end
end
