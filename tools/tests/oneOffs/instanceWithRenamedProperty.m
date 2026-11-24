function [instance, propertyName, schemaName] = instanceWithRenamedProperty()
% instanceWithRenamedProperty - An instance with a property the schema names differently
%
%   [instance, propertyName, schemaName] = instanceWithRenamedProperty()
%
%   Returns a populated instance of a type whose schema spells one
%   property name in a way that is not a valid MATLAB identifier, together
%   with the name the type declares for it and the name the schema uses.
%   The property holds a value, so a document written from the instance
%   has to carry the schema name.
%
%   The v4.0 model has no such property. The instance is then empty and
%   both names are "", and a test should assume the instance is not empty.

    if ommtest.oneoffs.currentSchemaMajorVersion() >= 5
        [instance, propertyName, schemaName] = ommtest.oneoffs.v5.instanceWithRenamedProperty();
    else
        instance = [];
        propertyName = "";
        schemaName = "";
    end
end
