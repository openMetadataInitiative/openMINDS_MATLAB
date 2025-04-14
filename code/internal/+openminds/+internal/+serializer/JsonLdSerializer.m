classdef JsonLdSerializer < openminds.internal.serializer.StructConverter
%JsonLdSerializer Class for converting/serializing metadata to JSON-LD

% Note: Might not be necessary to use a class for this

    methods

        function instances = convert(obj, outputMode)
        %serialize Serialize an openMINDS instance
            
            arguments
                obj
                outputMode (1,1) string = "single"
            end

            if numel(obj) > 1
                instances = arrayfun(@(o) o.convert(outputMode), obj, 'UniformOutput', false);
                return
            end

            instances = convert@openminds.internal.serializer.StructConverter(obj);

            if ~isa(instances, 'cell')
                instances = {instances};
            end
            
            switch outputMode
                case "single"
                    instances = obj.convertStructToJsonld(instances);
                case "multiple"
                    instances = cellfun(@(i) obj.convertStructToJsonld(i), instances, 'UniformOutput', false);
            end

            if numel(instances) == 1
                instances = instances{1};
            end
        end

        function instances = deserialize(obj) %#ok<MANU,STOUT>
            error('Not implemented')
            % Todo:
            % json to struct
            % struct to openminds instances
        end
    end

    methods (Access = private)

        function jsonStr = convertStructToJsonld(obj, instance)
        %convertStructToJsonld Convert a struct to a json ld
            jsonStr = openminds.internal.utility.json.encode(instance);
            jsonStr = strrep(jsonStr, 'VOCAB_URI_',  obj.VocabularyIRI);
        end

        function structInstance = convertJsonLdToStruct(obj, jsonInstance)
            jsonInstance = strrep(jsonInstance, obj.VocabularyIRI, '');
            structInstance = openminds.internal.utility.json.decode(jsonInstance);
        end
    end
end
