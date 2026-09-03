classdef MockGraphMetadataStore < openminds.interface.MetadataStore
% MockGraphMetadataStore - Metadata store backed by the mock graph database

    properties (SetAccess = immutable)
        Database ommtest.helper.mock.MockGraphDatabase
    end

    methods
        function obj = MockGraphMetadataStore(database)
            obj = obj@openminds.interface.MetadataStore();
            obj.Database = database;
            obj.Serializer = ommtest.helper.mock.MockGraphSerializer();
        end

        function identifiers = save(obj, instances, ~)
            if isa(instances, 'openminds.Collection')
                instances = instances.getAll();
            end
            records = obj.Serializer.serialize(instances);
            for i = 1:numel(records)
                obj.Database.put(records(i));
            end
            identifiers = [records.Identifier];
        end

        function instances = load(obj, ~)
            deserializer = ommtest.helper.mock.MockGraphDeserializer();
            instances = deserializer.deserialize(obj.Database.all());
        end
    end
end
