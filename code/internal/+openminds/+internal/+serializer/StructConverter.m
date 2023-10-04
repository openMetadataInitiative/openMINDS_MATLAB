classdef StructConverter < handle
%openminds.internal.serializer.StructConverter A json-ld serializer for openMINDS instances
%
%   This is a proposal for what a serializer class could look like. Some
%   unresolved questions remain.
%
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

    properties (Constant)
        DEFAULT_VOCAB = "https://openminds.ebrains.eu"
        LOCAL_IRI = "http://localhost"
    end

    properties 
        Depth = 0
    end

    properties
        Vocab
        SchemaType string % i.e https://openminds.ebrains.eu/core/Person
        MetadataModel string % i.e core
    end
    
    properties (Dependent)
        SchemaName string % i.e Person
    end

    properties 
        Instance % openminds.abstract.Schema
        id % Todo: get from instance...
    end

    properties (Access = private)
        SchemaInspector
    end

    methods % Constructor

        function obj = StructConverter( instanceObject, recursionDepth )
            
            if isa( instanceObject, 'openminds.internal.abstract.LinkedCategory' )
                instanceObject = instanceObject.Instance;
                warning('Please report if you see this warning!')
            end

            if numel(instanceObject) > 1
                error('Serialization of non-scalar objects is not supported yet')
            end

            if ~isa(instanceObject, 'openminds.abstract.Schema')
                error('Serializer input must be an openMINDS instance. The provided instance is of type "%s"', class(instanceObject))
            end

            if nargin > 1 && ~isempty(recursionDepth)
                obj.Depth = recursionDepth;
            end

            obj.Instance = instanceObject;
            obj.SchemaInspector = openminds.internal.SchemaInspector(instanceObject);

            obj.SchemaType = instanceObject.X_TYPE;

            obj.id = obj.Instance.id;

            if isempty(obj.Vocab)
                obj.Vocab = obj.DEFAULT_VOCAB;
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
    end

    methods 

        function S = convert(obj)
        %serialize Serialize an openMINDS instance
            
            S = obj.convertInstanceToStruct();
            %S{1} = obj.convertStructToJsonld(S{1});

            % Todo: 
            %   [ ] Test cell arrays where a property can have links to
            %       multiple different schema instances.
            %   [ ] Test arrays
            %   [ ] Test scalars
        end

    end

    methods (Access = private) % Note: Make protected if subclasses are created
        
        function C = convertInstanceToStruct(obj, instanceObject)
            
            if nargin < 2 || isempty(instanceObject)
                instanceObject = obj.Instance;
            end

            C = {};
            
            S = struct;

            S.at_context = struct();
            S.at_context.at_vocab = sprintf("%s/vocab", obj.Vocab);

            S.at_type = instanceObject.X_TYPE;
            S.at_id = obj.getIdentifier(instanceObject.id);
            
            % Get public properties
            propertyNames = properties(instanceObject);

            % Serialize each of the properties and values.
            for i = 1:numel(propertyNames)
                
                iPropertyName = propertyNames{i};
                iPropertyValue = instanceObject.(iPropertyName);
                
                iVocabPropertyName = sprintf('VOCAB_URI_%s', iPropertyName);

                % Skip properties where value is not set.
                if isempty(iPropertyValue); continue; end
                if isstring(iPropertyValue) && numel(iPropertyValue)==1 && iPropertyValue==""; continue; end

                % Handle linked, embedded and direct values.
                if obj.SchemaInspector.isPropertyWithLinkedType(iPropertyName)
                    [S.(iVocabPropertyName), L] = obj.convertLinkedInstanceToStruct(iPropertyValue);
                    C = [C, L];
                elseif obj.SchemaInspector.isPropertyWithEmbeddedType(iPropertyName)
                    [S.(iVocabPropertyName), L] = obj.convertEmbeddedInstanceToStruct(iPropertyValue);
                    C = [C, L];
                else
                    S.(iVocabPropertyName) = iPropertyValue;
                end

                toScalar = obj.SchemaInspector.isPropertyValueScalar(iPropertyName);
                if ~toScalar && numel(S.(iVocabPropertyName)) == 1
                    % Scalar values should still be serialized as array
                    S.(iVocabPropertyName) = {S.(iVocabPropertyName)};
                end
            end

            C = [{S}, C];
        end

        function jsonStr = convertStructToJsonld(obj, S)
            jsonStr = openminds.internal.utility.json.encode(S);
            jsonStr = strrep(jsonStr, 'VOCAB_URI_', sprintf('%s/vocab/', obj.DEFAULT_VOCAB) );
        end

        function [S, linkedInstances] = convertLinkedInstanceToStruct(obj, linkedInstance)

            S = struct('at_id', {});
            linkedInstances = {};
            
            for i = 1:numel(linkedInstance)
                iValue = obj.validateInstance(linkedInstance(i));
                S(i).at_id = obj.getIdentifier(iValue.id);
                
                if obj.Depth > 0
                    serializer = openminds.internal.serializer.StructConverter(iValue, obj.Depth-1);
                    S_ = serializer.convert();
                    linkedInstances = [linkedInstances, S_]; %#ok<AGROW> 
                end
            end
        end

        function [C, linkedInstances] = convertEmbeddedInstanceToStruct(obj, embeddedInstance)
            % Todo: Handle non-scalar
            
            C = cell(size(embeddedInstance));
            linkedInstances = {};

            for i = 1:numel(embeddedInstance)
                iValue = obj.validateInstance(embeddedInstance(i));
                serializer = openminds.internal.serializer.StructConverter(iValue, obj.Depth-1);
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
            if isa(instanceObject, 'openminds.internal.abstract.LinkedCategory')
                % Todo: linkedInstance(i) should return the instance directly
                instanceObject = instanceObject.Instance;
            elseif isa(instanceObject, 'openminds.abstract.Schema')
                % pass
            else
                error('Unknown instance type "s%"', class(instanceObject))
            end
        end

    end

    methods (Static)

        function id = getIdentifier(instanceID)
            if ~strncmp(instanceID, 'http', 4)
                id = sprintf("%s/%s", openminds.internal.serializer.StructConverter.LOCAL_IRI, instanceID);
            else
                id = instanceID;
            end
        end

    end

end