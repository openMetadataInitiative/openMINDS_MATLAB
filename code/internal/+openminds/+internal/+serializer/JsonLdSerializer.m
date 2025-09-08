classdef JsonLdSerializer < openminds.internal.serializer.BaseSerializer
%JsonLdSerializer Serializer for JSON-LD format
%
%   This class extends BaseSerializer to provide JSON-LD specific
%   serialization for openMINDS instances.
%
%   USAGE:
%   ------
%   serializer = JsonLdSerializer();
%   result = serializer.serialize(instances);
%
%   FEATURES:
%   ---------
%   - Converts processed structs to JSON-LD strings
%   - Handles vocabulary URI replacement
%   - Supports single and multiple instance serialization
%   - Maintains JSON-LD compliance


    methods
        function obj = JsonLdSerializer(config)

            arguments
                config.?openminds.internal.serializer.SerializationConfig
            end
            nvPairs = namedargs2cell(config);

            obj = obj@openminds.internal.serializer.BaseSerializer(nvPairs)
        end
    end

    methods (Access = protected)
        function result = formatOutput(obj, processedStruct, config)
        %formatOutput Convert processed struct to JSON-LD string
        %
        %   result = formatOutput(obj, processedStruct, config)
        %   converts the processed struct(s) to JSON-LD formatted string(s)
        %
        %   PARAMETERS:
        %   -----------
        %   processedStruct : struct or cell array of structs
        %       Struct(s) with openMINDS fields (@type, @id, etc.) added
        %   config : SerializationConfig
        %       Configuration object for serialization
        %
        %   RETURNS:
        %   --------
        %   result : string or cell array of strings
        %       JSON-LD formatted string(s)
            
            arguments
                obj (1,1) openminds.internal.serializer.JsonLdSerializer
                processedStruct % struct or cell array of structs
                config % SerializationConfig object
            end
            
            if iscell(processedStruct) && ~isscalar(processedStruct)
                % Handle multiple instances
                if config.OutputMode == "multiple"
                    result = cell(size(processedStruct));
                    for i = 1:numel(processedStruct)
                        result{i} = obj.convertStructToJsonLd(processedStruct{i}, config);
                    end
                else
                    processedStruct = struct( ...
                        'at_context', {struct('at_vocab', obj.DefaultVocabularyIRI)}, ...
                        'at_graph', {processedStruct} ...
                    );
                    result = obj.convertStructToJsonLd(processedStruct, ...
                        "UseSemanticPropertyName", false);
                end
            else
                % Handle single instance
                result = obj.convertStructToJsonLd(processedStruct, config);
            end
        end
    end


    methods (Access = private)
        function jsonStr = convertStructToJsonLd(obj, structInstance, config)
        %convertStructToJsonLd Convert a single struct to JSON-LD string
        %
        %   jsonStr = convertStructToJsonLd(obj, structInstance, config)
        %   converts a single processed struct to a JSON-LD string
            
            arguments
                obj (1,1) openminds.internal.serializer.JsonLdSerializer
                structInstance (1,1) struct
                config % SerializationConfig object
            end
            
            % Apply semantic property naming if requested
            if config.UseSemanticPropertyName
                structInstance = obj.applySemanticPropertyNames(structInstance);
            end
            
            % Convert to JSON string
            if config.PrettyPrint
                jsonStr = openminds.internal.utility.json.encode(structInstance, 'PrettyPrint', true);
            else
                jsonStr = openminds.internal.utility.json.encode(structInstance);
            end
            
            % Replace vocabulary URI placeholders if semantic naming was used
            if config.UseSemanticPropertyName
                vocabUri = obj.DefaultVocabularyIRI;
                jsonStr = strrep(jsonStr, 'VOCAB_URI_', vocabUri);
            end
        end
        
        function structInstance = applySemanticPropertyNames(obj, structInstance)
        %applySemanticPropertyNames Apply semantic property naming
        %
        %   structInstance = applySemanticPropertyNames(obj, structInstance)
        %   replaces property names with semantic vocabulary URIs
            
            arguments
                obj (1,1) openminds.internal.serializer.JsonLdSerializer
                structInstance (1,1) struct
            end
            
            fieldNames = fieldnames(structInstance);
            
            for i = 1:numel(fieldNames)
                fieldName = fieldNames{i};
                
                % Skip special JSON-LD fields
                if startsWith(fieldName, 'at_')
                    continue
                end
                
                % Create semantic property name
                semanticName = sprintf('VOCAB_URI_%s', fieldName);
                
                % Rename the field
                structInstance.(semanticName) = structInstance.(fieldName);
                structInstance = rmfield(structInstance, fieldName);
                
                % Recursively apply to nested structs
                if isstruct(structInstance.(semanticName))
                    if isscalar(structInstance.(semanticName))
                        structInstance.(semanticName) = obj.applySemanticPropertyNames(structInstance.(semanticName));
                    else
                        % Handle struct arrays
                        for j = 1:numel(structInstance.(semanticName))
                            structInstance.(semanticName)(j) = obj.applySemanticPropertyNames(structInstance.(semanticName)(j));
                        end
                    end
                elseif iscell(structInstance.(semanticName))
                    % Handle cell arrays of structs
                    for j = 1:numel(structInstance.(semanticName))
                        if isstruct(structInstance.(semanticName){j})
                            structInstance.(semanticName){j} = obj.applySemanticPropertyNames(structInstance.(semanticName){j});
                        end
                    end
                end
            end
        end
    end
    
    methods (Static)
        function jsonStr = serializeToJsonLd(instances, options)
        %serializeToJsonLd Static convenience method for JSON-LD serialization
        %
        %   jsonStr = JsonLdSerializer.serializeToJsonLd(instances)
        %   serializes instances to JSON-LD using default configuration
        %
        %   jsonStr = JsonLdSerializer.serializeToJsonLd(instances, Name, Value, ...)
        %   serializes instances with custom configuration options
        %
        %   PARAMETERS:
        %   -----------
        %   instances : openminds.abstract.Schema or cell array
        %       Instance(s) to serialize
        %
        %   Configuration options (Name-Value pairs):
        %   RecursionDepth : integer (default: 1)
        %   WithContext : logical (default: true)
        %   PrettyPrint : logical (default: true)
        %   UseSemanticPropertyName : logical (default: false)
        %   IncludeEmptyProperties : logical (default: false)
        %
        %   RETURNS:
        %   --------
        %   jsonStr : string or cell array of strings
        %       JSON-LD formatted string(s)
            
            arguments
                instances % openminds.abstract.Schema or cell array
                options.RecursionDepth (1,1) {mustBeInteger, mustBeNonnegative} = 1
                options.WithContext (1,1) logical = true
                options.PrettyPrint (1,1) logical = true
                options.UseSemanticPropertyName (1,1) logical = false
                options.IncludeEmptyProperties (1,1) logical = false
                options.IncludeIdentifier (1,1) logical = true
            end
            
            % Create configuration
            config = SerializationConfig( ...
                'Format', 'jsonld', ...
                'RecursionDepth', options.RecursionDepth, ...
                'WithContext', options.WithContext, ...
                'PrettyPrint', options.PrettyPrint, ...
                'UseSemanticPropertyName', options.UseSemanticPropertyName, ...
                'IncludeEmptyProperties', options.IncludeEmptyProperties, ...
                'IncludeIdentifier', options.IncludeIdentifier);
            
            % Create serializer and serialize
            serializer = openminds.internal.serializer.JsonLdSerializer();
            jsonStr = serializer.serialize(instances, config);
        end
    end
end
