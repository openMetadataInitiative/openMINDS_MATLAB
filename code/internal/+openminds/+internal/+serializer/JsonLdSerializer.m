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
%   - Handles vocabulary IRI replacement
%   - Supports single and multiple instance serialization

    properties (Constant)
        DefaultFileExtension = ".jsonld"
    end

    methods
        function obj = JsonLdSerializer(config)

            arguments
                config.?openminds.internal.serializer.SerializationConfig
            end
            nvPairs = namedargs2cell(config);
            obj = obj@openminds.internal.serializer.BaseSerializer(nvPairs{:});
        end
    end

    methods (Access = protected)
        function allStructs = postProcessInstances(obj, allStructs)
        % postProcessInstances - Processes instances to apply vocabulary
        % mapping or semantic property naming based on the configuration settings.
        %
        % Syntax:
        %   allStructs = postProcessInstances(obj, allStructs)
        %   This function modifies 'allStructs' by adding vocabulary mapping or
        %   applying semantic property names depending on the object's serialization
        %   configuration.
        %
        % Input Arguments:
        %   obj - An object containing serialization configuration and methods
        %   allStructs - A cell array of structures to be processed
        %
        % Output Arguments:
        %   allStructs - The processed cell array of structures after applying
        %   the necessary transformations
        
            arguments
                obj (1,1) openminds.internal.serializer.JsonLdSerializer
                allStructs (1,:) {mustBeCellOfStructs}
            end
        
            % Normalize empty values to ensure they get encoded to null
            if obj.SerializationConfiguration.IncludeEmptyProperties
                for i = 1:numel(allStructs)
                    allStructs{i} = obj.normalizeEmptyProperties(allStructs{i});
                end
            end
            
            if obj.SerializationConfiguration.OutputMode == "multiple"
                % Add vocabulary mapping to @context if requested.
                if obj.SerializationConfiguration.PropertyNameSyntax == "compact"
                    % Add to each document
                    for i = 1:numel(allStructs)
                        allStructs{i} = obj.addVocabularyMapping(allStructs{i});
                    end
                end
            end
        
            % Apply semantic property naming (expanded json-ld form) if requested
            if obj.SerializationConfiguration.PropertyNameSyntax == "expanded"
                for i = 1:numel(allStructs)
                    allStructs{i} = obj.applySemanticPropertyNames(allStructs{i});
                end
            end
            
            allStructs = obj.sortKeys(allStructs);
        
            if obj.SerializationConfiguration.OutputMode == "single"
                allStructs = obj.createCollectionDocument(allStructs);
                % Need to return cell of structs
                allStructs = {allStructs};
            end
        end

        function result = formatOutput(obj, processedStruct)
        %formatOutput Convert processed struct to JSON-LD string
        %
        %   result = formatOutput(obj, processedStruct, config)
        %   converts the processed struct(s) to JSON-LD formatted string(s)
        %
        %   PARAMETERS:
        %   -----------
        %   processedStruct : cell array of structs with openMINDS fields
        %       (@type, @id, etc.) added
        %
        %   RETURNS:
        %   --------
        %   result : string or cell array of strings
        %       JSON-LD formatted string(s)
            
            arguments
                obj (1,1) openminds.internal.serializer.JsonLdSerializer
                processedStruct (1,:) {mustBeCellOfStructs}
            end
            
            result = cell(1, numel(processedStruct));
            for i = 1:numel(processedStruct)
                result{i} = obj.convertStructToJsonLd(processedStruct{i});
            end

            if iscell(result) && isscalar(result)
                result = result{1};
            end
        end
    end

    methods (Access = private)
        function S = addVocabularyMapping(obj, S)
        % addVocabularyMapping - Add vocabulary mapping to json-ld @context key
            arguments
                obj (1,1) openminds.internal.serializer.JsonLdSerializer
                S (1,1) struct
            end
        
            % Ensure @context exists and is a struct
            if ~isfield(S, 'at_context') || ~isstruct(S.('at_context'))
                S.('at_context') = struct();
            end
            
            % Set @vocab (preserve any other context entries)
            S.('at_context').('at_vocab') = obj.DefaultVocabularyIRI;
        end

        function jsonStr = convertStructToJsonLd(obj, structInstance)
        %convertStructToJsonLd Convert a single struct to JSON-LD string
        %
        %   jsonStr = convertStructToJsonLd(obj, structInstance)
        %   converts a single processed struct to a JSON-LD string
            
        % This function converts a structure to a json-ld document,
        % providing workaround for MATLAB limitation that fieldnames of
        % structures can only contain alphanumerics and underscores.

            arguments
                obj (1,1) openminds.internal.serializer.JsonLdSerializer
                structInstance (1,1) struct
            end
            
            config = obj.SerializationConfiguration;

            % Convert to JSON string
            jsonStr = openminds.internal.utility.json.encode(structInstance, ...
                'PrettyPrint', config.PrettyPrint);
        
            % Replace vocabulary URI placeholders if semantic naming was used
            if config.PropertyNameSyntax == "expanded"
                vocabIRI = obj.DefaultVocabularyIRI;
                
                % Pattern matches ONLY JSON object keys of form:
                %   "VOCAB_URI_<word>"   (optional spaces) :
                % Capturing <word> for reinsertion after the vocabulary IRI.
                % We restrict <word> to MATLAB identifier pattern [A-Za-z0-9_]+
                % because applySemanticPropertyNames only ever generates that.
                propertyKeyPattern = '"VOCAB_URI_([A-Za-z0-9_]+)"\s*:';
                replacement = ['"' char(vocabIRI) '$1":'];
                jsonStr = regexprep(jsonStr, propertyKeyPattern, replacement);
            end
        end

        function structInstance = applySemanticPropertyNames(obj, structInstance)
        %applySemanticPropertyNames - Apply semantic property naming
        %
        %   structInstance = applySemanticPropertyNames(obj, structInstance)
        %   replaces property names with semantic vocabulary URIs
        %
        %   This function recursively prepends the "VOCAB_URI_" placeholder
        %   to all property names (non -jsonld keywords) of a structure.
        %   After conversion to jsonld, these placeholders will be replaced
        %   with the actual vocabulary IRI.
            
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
                
                % Sanity check
                assert(~startsWith(fieldName, 'VOCAB_URI_'), ...
                    ['Internal error: Did not expect property name to ', ...
                    'start with "VOCAB_URI" placeholder'] )

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

        function document = createCollectionDocument(obj, documentList)
        % createCollectionDocument - Combine all documents into a
        % "collection document using the @graph keyword
            arguments
                obj (1,1) openminds.internal.serializer.JsonLdSerializer
                documentList (1,:) cell {mustBeCellOfStructs}
            end

            document = struct();

            if obj.SerializationConfiguration.PropertyNameSyntax == "compact"
                document = obj.addVocabularyMapping(document);
            end
            document.at_graph = documentList;
        end
    
        function S = normalizeEmptyProperties(obj, S)
            propNames = fieldnames(S);
            propValues = struct2cell(S);

            for i = 1:numel(propValues)
                iPropertyValue = propValues{i};
                if obj.isEmptyPropertyValue(iPropertyValue)
                    iPropertyName = propNames{i};
                    % This will encode to null in jsonencode
                    S.(iPropertyName) = string(missing);
                end
            end
        end
    end

    methods (Static, Access = private)
        function allStructs = sortKeys(allStructs)
        % sortKeys - Sorts the keys of the given structs based on a predefined order.
        %
        % Sort by placing json-ld keywords first, then property names in
        % alphabetical order
        %
        % Syntax:
        %   allStructs = sortKeys(obj, allStructs)
        %
        % Input Arguments:
        %   obj          - An object which may contain relevant properties for sorting.
        %   allStructs   - An array of structures to be sorted by key order.
        %
        % Output Arguments:
        %   allStructs   - The input structures sorted with keys in a specific order.
        
            arguments
                allStructs (1,:) cell {mustBeCellOfStructs}
            end

            jsonLdKeywords = ["at_context", "at_id", "at_type", "at_graph"];
            for i = 1:numel(allStructs)
                allFieldNames = string( fieldnames(allStructs{i}) );
                allFieldNames = reshape(allFieldNames, 1, []); % Ensure row
                
                jsonLdKeywordFields = intersect(allFieldNames, jsonLdKeywords);
                propertyFields = setdiff(allFieldNames, jsonLdKeywords);

                fieldOrder = [ ...
                    intersect(jsonLdKeywords, jsonLdKeywordFields, "stable"), ...
                    sort(propertyFields) ];

                fieldOrder = cellstr(fieldOrder);
                
                allStructs{i} = orderfields(allStructs{i}, fieldOrder);
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
                options.PrettyPrint (1,1) logical = true
                options.PropertyNameSyntax (1,1) string {mustBeMember(options.PropertyNameSyntax, ["compact","expanded"])} = "compact"
                options.IncludeEmptyProperties (1,1) logical = false
                options.IncludeIdentifier (1,1) logical = true
            end
            
            % Create serializer and serialize
            serializer = openminds.internal.serializer.JsonLdSerializer(...
                'RecursionDepth', options.RecursionDepth, ...
                'PrettyPrint', options.PrettyPrint, ...
                'PropertyNameSyntax', options.PropertyNameSyntax, ...
                'IncludeEmptyProperties', options.IncludeEmptyProperties, ...
                'IncludeIdentifier', options.IncludeIdentifier);
            jsonStr = serializer.serialize(instances);
        end
    end
end

function mustBeCellOfStructs(cellArray)
    arguments
        cellArray (1,:) cell
    end

    if isempty(cellArray), return; end

    isCellOfStruct = cellfun(@isstruct, cellArray);
    assert(all(isCellOfStruct), ...
        "openMINDS_MATLAB:Validator:MustBeCellOfStruct", ...
        'Expected input to be a cell array of structures.')
end
