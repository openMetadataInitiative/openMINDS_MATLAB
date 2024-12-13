classdef StructConverter < handle
%openminds.internal.serializer.StructConverter A json-ld serializer for openMINDS instances
%
%   This is a proposal for what a serializer class could look like. Some
%   unresolved questions remain.

%     TODO:
%     -----
%     - Simplify recursiveness
%
%     QUESTIONS:
%     ----------
%     - Consider whether it is enough to have a mixin, or we should use the
%       strategy pattern and have Serializer as a property of Instance in
%       order to flexibly change between different serialization techniques.
        
% Note: recursion depth only applies to linked properties, not embedded.

    properties % Options than can be set on object construction
        % Specifies how many linked types to recursively convert to structs
        RecursionDepth = 0

        % Whether to add the @context property to the output struct
        WithContext (1,1) logical = true

        % Whether to include empty properties in the output struct
        IncludeEmptyProperties (1,1) logical = true

        % Whether to embed linked types in the output struct
        EmbedLinkedNodes (1,1) logical = false
    end

    properties (SetAccess = private)
        SchemaType string % i.e https://openminds.ebrains.eu/core/Person
        MetadataModel string % i.e core
    end
    
    properties (Dependent)
        SchemaName string % i.e Person
    end

    properties (SetAccess = immutable)
        Instance % openminds.abstract.Schema
        id % Todo: get from instance...
    end

    properties (Access = private)
        SchemaInspector
    end

    properties (Constant, Access = protected)
        OPENMINDS_IRI = "https://openminds.ebrains.eu"
        LOCAL_IRI = "http://localhost"
    end

    properties (Access = protected, Dependent)
        VocabularyIRI
    end

    methods % Constructor

        function obj = StructConverter( instanceObject, options )
            
            arguments
                % An instance or array of instances
                instanceObject

                % Options for converter (public properties of class)
                options.?openminds.internal.serializer.StructConverter
            end

            if openminds.utility.isMixedInstance(instanceObject)
                instanceObject = instanceObject.Instance;
                warning('Please report if you see this warning!')
            end

            nvOptions = namedargs2cell(options);

            if numel(instanceObject) > 1 || iscell(instanceObject)
                className = class(obj);
                nvOptions = namedargs2cell(options);
                obj = cellfun(@(c) feval(className, c, nvOptions{:}), instanceObject);
                return
                % error('Serialization of non-scalar objects is not supported yet')
            end

            if isa(instanceObject, 'struct') && isfield(instanceObject, 'id')
                obj.Instance = instanceObject;
            else
                if ~openminds.utility.isInstance( instanceObject )
                    error('Serializer input must be an openMINDS instance. The provided instance is of type "%s"', class(instanceObject))
                else
                    obj.assignNameValueOptions(nvOptions)
        
                    obj.Instance = instanceObject;
                    obj.SchemaInspector = openminds.internal.SchemaInspector(instanceObject);
        
                    obj.SchemaType = instanceObject.X_TYPE;
        
                    obj.id = obj.Instance.id;
                end
            end

            if ~nargout
                obj.convert()
                clear obj
            end
        end
    end

    methods
        function name = get.SchemaName(obj)

            if isempty(obj.SchemaType)
                name = '';
            else
                schemaTypeSplit = strsplit(obj.SchemaType, '/');
                name = schemaTypeSplit{end};
            end
        end
                
        function vocabularyIRI = get.VocabularyIRI(obj)
            vocabularyIRI = sprintf('%s/vocab/', obj.OPENMINDS_IRI);
        end
    end

    methods

        function S = convert(obj)
        %serialize Serialize an openMINDS instance

            S = arrayfun(@(o) o.convertInstanceToStruct(), obj, 'UniformOutput', true);
            % S{1} = obj.convertStructToJsonld(S{1});

            % Todo:
            %   [ ] Test cell arrays where a property can have links to
            %       multiple different schema instances.
            %   [ ] Test arrays
            %   [ ] Test scalars
        end
    end

    methods (Access = private) % Note: Make protected if subclasses are created
        
        % Unpack name-value pairs and assign to properties.
        function assignNameValueOptions(obj, nvOptions)
            optionNames = nvOptions(1:2:end);
            optionValues = nvOptions(2:2:end);

            for i = 1:numel(optionNames)
                obj.(optionNames{i}) = optionValues{i};
            end
        end

        function C = convertInstanceToStruct(obj, instanceObject)
            
            if nargin < 2 || isempty(instanceObject)
                instanceObject = obj.Instance;
            end

            C = {};
            
            S = struct;

            if obj.WithContext
                S.at_context = struct();
                S.at_context.at_vocab = obj.VocabularyIRI;
            end

            if isa(obj.Instance, 'struct')
                S.at_id = obj.Instance.id;
                C = {S};
                return
            end
            
            S.at_id = obj.getIdentifier(instanceObject.id);
            S.at_type = instanceObject.X_TYPE;
            
            % Get public properties
            propertyNames = properties(instanceObject);

            % Serialize each of the properties and values.
            for i = 1:numel(propertyNames)
                
                iPropertyName = propertyNames{i};
                iPropertyValue = instanceObject.(iPropertyName);
                
                % iVocabPropertyName = sprintf('VOCAB_URI_%s', iPropertyName);
                iVocabPropertyName = iPropertyName;

                % Skip properties where value is not set.
                if isempty(iPropertyValue); continue; end
                if isstring(iPropertyValue) && numel(iPropertyValue)==1 && iPropertyValue==""; continue; end
                if isstring(iPropertyValue) && numel(iPropertyValue)==1 && ismissing(iPropertyValue); continue; end

                % Handle linked, embedded and direct values.
                if obj.SchemaInspector.isPropertyWithLinkedType(iPropertyName)
                    [S.(iVocabPropertyName), L] = obj.convertLinkedInstanceToStruct(iPropertyValue);
                    C = [C, L]; %#ok<AGROW>
                elseif obj.SchemaInspector.isPropertyWithEmbeddedType(iPropertyName)
                    [S.(iVocabPropertyName), L] = obj.convertEmbeddedInstanceToStruct(iPropertyValue);
                    C = [C, L]; %#ok<AGROW>
                else
                    S.(iVocabPropertyName) = iPropertyValue;
                end

                toScalar = obj.SchemaInspector.isPropertyValueScalar(iPropertyName);
                if ~toScalar && numel(S.(iVocabPropertyName)) == 1
                    % Scalar values should still be serialized as array if
                    % property allows lists
                    S.(iVocabPropertyName) = {S.(iVocabPropertyName)};
                end
            end

            C = [{S}, C];
        end

        function jsonStr = convertStructToJsonld(obj, S)
            jsonStr = openminds.internal.utility.json.encode(S);
            jsonStr = strrep(jsonStr, 'VOCAB_URI_', sprintf('%s/vocab/', obj.OPENMINDS_IRI) );
        end

        function [S, linkedInstances] = convertLinkedInstanceToStruct(obj, linkedInstance)

            S = struct('at_id', {});
            linkedInstances = {};
            
            for i = 1:numel(linkedInstance)
                if isstruct(linkedInstance(i))
                    S(i).at_id = linkedInstance(i).id;
                else
                    iValue = obj.validateInstance(linkedInstance(i));
                    S(i).at_id = obj.getIdentifier(iValue.id);
                    
                    if obj.RecursionDepth > 0
                        serializer = openminds.internal.serializer.StructConverter(iValue, obj.RecursionDepth-1);
                        S_ = serializer.convert();
                        linkedInstances = [linkedInstances, S_]; %#ok<AGROW>
                    end
                end
            end
        end

        function [C, linkedInstances] = convertEmbeddedInstanceToStruct(obj, embeddedInstance)
            % Todo: Handle non-scalar
            
            C = cell(size(embeddedInstance));
            linkedInstances = {};

            for i = 1:numel(embeddedInstance)
                iValue = obj.validateInstance(embeddedInstance(i));
                serializer = openminds.internal.serializer.StructConverter(iValue, 'RecursionDepth', obj.RecursionDepth-1);
                S = serializer.convertInstanceToStruct;
                S{1} = rmfield(S{1}, {'at_context', 'at_id'});
                C{i} = S{1};
                linkedInstances = [linkedInstances, S(2:end)]; %#ok<AGROW>
            end
            
            try
                C = cat(1, C{:});
            catch
                % pass
            end
        end

        function instanceObject = validateInstance(~, instanceObject)
            if openminds.utility.isMixedInstance(instanceObject)
                % Todo: linkedInstance(i) should return the instance directly
                instanceObject = instanceObject.Instance;
            elseif openminds.utility.isInstance(instanceObject)
                % pass
            elseif isa(instanceObject, 'struct') && isfield(instanceObject, 'id')
                % pass
            else
                error('Unknown instance type "%s"', class(instanceObject))
            end
        end
    end

    methods (Static)

        function id = getIdentifier(instanceID)
            id = instanceID;

            % % Deprecate the localhost id?
            % % if ~strncmp(instanceID, 'http', 4)
            % %     id = sprintf("%s/%s", openminds.internal.serializer.StructConverter.LOCAL_IRI, instanceID);
            % % else
            % %     id = instanceID;
            % % end
        end
    end
end
