classdef JsonLdSerializer < openminds.internal.serializer.StructConverter
    
    properties (Dependent)
        VocabBaseUri
    end

    methods
        function vocabBaseUri = get.VocabBaseUri(obj)
            vocabBaseUri = sprintf('%s/vocab/', obj.DEFAULT_VOCAB);
        end
    end

    methods 

        function instances = convert(obj)
        %serialize Serialize an openMINDS instance

            instances = convert@openminds.internal.serializer.StructConverter(obj);

            if ~isa(instances, 'cell')
                instances = {instances};
            end

            for i = 1:numel(instances)
                instances{i} = obj.convertStructToJsonld(instances{i});
            end

            if numel(instances) == 1
                instances = instances{1};
            end
        end

        function instances = deserialize(obj)
            % Todo:
            % json to struct
            % struct to openminds instances
        end

    end

    methods (Access = private)

        function jsonStr = convertStructToJsonld(obj, instance)
        %convertStructToJsonld Convert a struct to a json ld
            jsonStr = openminds.internal.utility.json.encode(instance);
            jsonStr = strrep(jsonStr, 'VOCAB_URI_',  obj.VocabBaseUri);
        end

        function structInstance = convertJsonLdToStruct(obj, jsonInstance)
            jsonInstance = strrep(jsonInstance, obj.VocabBaseUri, '');
            structInstance = openminds.internal.utility.json.decode(jsonInstance);
        end

    end

end