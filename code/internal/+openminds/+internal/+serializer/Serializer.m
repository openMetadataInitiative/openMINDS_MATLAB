classdef Serializer < handle
%openminds.internal.serializer.Serializer A json-ld serializer for openMINDS instances
%
%   This is a proposal for what a serializer class could look like. Some
%   unresolved todos and questions remain.

%     TODO:
%     -----
%     - [ ] Handle non-scalar embedded instances
%     - [ ] Handle openminds.internal.abstract.LinkedCategory instances

%     QUESTIONS:
%     ----------
%     - Consider whether it is enough to have a mixin, or we should use the 
%       strategy pattern and have Serializer as a property of Instance in 
%       order to flexibly change between different serialization techniques.
%
%     - Should the serializer work recursively, or should that be managed
%       somewhere else, i.e MetadataCollection
        

    properties (Constant)
        DEFAULT_VOCAB = "https://openminds.ebrains.eu"
        LOCAL_IRI = "http://localhost"
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

        function obj = Serializer( instanceObject )
            
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

            obj.Instance = instanceObject;
            obj.SchemaInspector = openminds.internal.SchemaInspector(instanceObject);

            obj.SchemaType = instanceObject.X_TYPE;

            obj.id = obj.Instance.id;

            if isempty(obj.Vocab)
                obj.Vocab = obj.DEFAULT_VOCAB;
            end

            if ~nargout
                obj.serialize()
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

        function jsonStr = serialize(obj)
        %serialize Serialize an openMINDS instance
            
            S = obj.convertInstanceToStruct();
            jsonStr = obj.convertStructToJsonld(S);

            % Todo: 
            %   [ ] Test cell arrays where a property can have links to
            %       multiple different schema instances.
            %   [ ] Test arrays
            %   [ ] Test scalars
        end

    end

    methods (Access = private) % Note: Make protected if subclasses are created
        
        function S = convertInstanceToStruct(obj, instanceObject)
            
            if nargin < 2 || isempty(instanceObject)
                instanceObject = obj.Instance;
            end
            
            S = struct;

            S.at_context = struct();
            S.at_context.at_vocab = sprintf("%s/vocab", obj.Vocab);

            S.at_type = {instanceObject.X_TYPE}; % Todo: Array or scalar?
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
                if isstring(iPropertyValue) && iPropertyValue==""; continue; end

                % Handle linked, embedded and direct values.
                if obj.SchemaInspector.isPropertyWithLinkedType(iPropertyName)
                    toScalar = obj.SchemaInspector.isPropertyValueScalar(iPropertyName);
                    S.(iVocabPropertyName) = obj.convertLinkedInstanceToStruct(iPropertyValue, 'ToScalar', toScalar);

                elseif obj.SchemaInspector.isPropertyWithEmbeddedType(iPropertyName)
                    S.(iVocabPropertyName) = obj.convertEmbeddedInstanceToStruct(iPropertyValue);
                else
                    S.(iVocabPropertyName) = iPropertyValue;
                end
            end
        end

        function jsonStr = convertStructToJsonld(obj, S)
            jsonStr = openminds.internal.utility.json.encode(S);
            jsonStr = strrep(jsonStr, 'VOCAB_URI_', sprintf('%s/vocab/', obj.DEFAULT_VOCAB) );
        end

        function S = convertLinkedInstanceToStruct(obj, linkedInstance, options)

            arguments
                obj
                linkedInstance
                options.ToScalar = True
            end

            S = struct('at_id', {});
            
            for i = 1:numel(linkedInstance)
                if isa(linkedInstance(i), 'openminds.internal.abstract.LinkedCategory')
                    % Todo: linkedInstance(i) should return the instance directly
                    iValue = linkedInstance(i).Instance;
                else
                    iValue = linkedInstance(i);
                end
                S(i).at_id = obj.getIdentifier(iValue.id);
            end

            if ~options.ToScalar && numel(S) == 1
                % Scalar ID should still be serialized as array
                S = {S};
            end
        end

        function S = convertEmbeddedInstanceToStruct(obj, embeddedInstance)
            % Todo: Handle non-scalar
            S = obj.convertInstanceToStruct(embeddedInstance);
            S = rmfield(S, {'at_context', 'at_id'});
        end

    end

    methods (Static)

        function id = getIdentifier(instanceID)
            id = sprintf("%s/%s", openminds.internal.serializer.Serializer.LOCAL_IRI, instanceID);
        end

    end

end