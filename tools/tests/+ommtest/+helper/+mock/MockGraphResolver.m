classdef MockGraphResolver < openminds.interface.LinkResolver
% MockGraphResolver - Resolves references against the mock graph database
%
%   Holds the database client as instance state, which the instance-method
%   resolver contract exists for. Populates a reference in place when its
%   type is known, and builds an instance of the recorded type when not.

    properties (Constant)
        IRIPrefix = "https://graph.example/instances/"
    end

    properties (SetAccess = immutable)
        Database ommtest.helper.mock.MockGraphDatabase
    end

    methods
        function obj = MockGraphResolver(database)
            obj.Database = database;
        end

        function instance = resolveNode(obj, instance)
            record = obj.Database.get(instance.id);
            data = jsondecode(char(record.Document));

            if isa(instance, 'openminds.internal.MixedTypeReference')
                % The type was unknown until now: build the recorded type
                typeEnum = openminds.enum.Types.fromAtType(record.TypeIRI);
                instance = feval(typeEnum.ClassName, data);
            else
                instance.fromStruct(data);
            end
        end

        function tf = canResolve(obj, IRI)
            tf = all(startsWith(IRI, obj.IRIPrefix));
        end
    end
end
