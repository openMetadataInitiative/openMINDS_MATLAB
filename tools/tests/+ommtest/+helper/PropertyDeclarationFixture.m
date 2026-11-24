classdef PropertyDeclarationFixture
%PropertyDeclarationFixture Property declarations for meta.Type tests
%
%   Exists only to be introspected. It carries one property of each
%   declaration shape that openminds.introspection.MetaType has to interpret,
%   so those tests do not depend on a particular openMINDS model version
%   happening to contain an example of each shape.

    properties
        % Restricted to a scalar by a validator rather than by its size,
        % which is how the generated type classes declare scalar
        % properties.
        scalarByValidator (1,:) string {mustBeScalarOrEmpty(scalarByValidator)}

        % Restricted to a scalar by its size declaration.
        scalarBySize (1,1) string

        % Not restricted to a scalar.
        unrestrictedList (1,:) string

        % Declared without a class. The generated type classes contain
        % such properties where the model does not resolve to a type.
        withoutDeclaredClass (1,:)

        % Declared under a name of MATLAB's choosing, because the schema
        % name is not a valid identifier. The schema name is recorded in
        % PROPERTY_NAME_MAP, as the generated type classes do.
        renamedBySchema (1,1) string
    end

    properties (Constant, Hidden)
        PROPERTY_NAME_MAP = struct('renamedBySchema', 'renamed-by-schema')
    end
end
