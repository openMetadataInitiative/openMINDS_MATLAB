function node = renameDecodedSchemaProperties(node, className)
%renameDecodedSchemaProperties Give a decoded node the property names of its type
%
%   node = renameDecodedSchemaProperties(node, className) renames the
%   fields of a decoded document node from the names the schema uses to
%   the names the type class declares, for the properties where the two
%   differ.
%
%   A schema name that is not a valid MATLAB identifier, such as
%   "z-stepSize", cannot survive decoding: jsondecode rewrites it with
%   matlab.lang.makeValidName, to "z_stepSize", which names no property of
%   the type and would be dropped. The field is found under that rewritten
%   spelling and moved to the property the type declares for it.
%
%   An embedded value carries its own @type and is renamed for that type.
%   One of a type the active model does not know is left as it is; reading
%   the node then fails, and the deserializer reports it.
%
%   Input Arguments:
%     node      - Decoded node, as a scalar struct.
%     className - Fully qualified class name of the node's type.
%
%   Output Arguments:
%     node - The node with its fields named as the type declares them.
%
%   See also openminds.introspection.MetaType,
%   openminds.internal.serializer.jsonld.SchemaPropertyName

    arguments
        node (1,1) struct
        className (1,1) string
    end

    metaType = openminds.introspection.fromClassName(className);

    for propertyName = metaType.RenamedPropertyNames
        decodedName = matlab.lang.makeValidName(metaType.getSchemaPropertyName(propertyName));
        if isfield(node, decodedName) && ~isfield(node, propertyName)
            node.(propertyName) = node.(decodedName);
            node = rmfield(node, decodedName);
        end
    end

    for fieldName = string(fieldnames(node))'
        value = node.(fieldName);
        if isstruct(value)
            node.(fieldName) = renameEach(value);
        elseif iscell(value)
            node.(fieldName) = cellfun(@renameIfNode, value, 'UniformOutput', false);
        end
    end
end

function values = renameEach(values)
% Rename every element of a struct array, which keeps its shape.
%
%   The elements of a struct array share their fields, so they are
%   renamed one by one and put back together.

    renamed = arrayfun(@renameIfNode, values, 'UniformOutput', false);
    values = reshape([renamed{:}], size(values));
end

function value = renameIfNode(value)
% Rename a value that is a node of a known type; leave anything else.

    if ~isstruct(value) || ~isscalar(value) || ~isfield(value, 'at_type')
        return
    end

    className = classNameOfType(value.at_type);
    if className == ""
        return
    end

    value = openminds.internal.serializer.renameDecodedSchemaProperties(value, className);
end

function className = classNameOfType(atType)
% Class of a node's @type, or "" when the active model does not know it.

    className = "";

    if ~(ischar(atType) || (isstring(atType) && isscalar(atType)))
        return
    end

    try
        className = string(openminds.enum.Types.fromAtType(atType).ClassName);
    catch
        % Not a type of this model. The node keeps its fields, and the
        % deserializer reports it when it cannot be read.
    end
end
