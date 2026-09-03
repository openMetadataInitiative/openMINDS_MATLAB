function collection = buildInteropCollection(specPath)
%buildInteropCollection Build the interoperability collection from its spec
%
%   collection = ommtest.helper.buildInteropCollection(specPath) builds the
%   collection described by the fixture specification natively, so its
%   export can be compared with the export of the same specification built
%   by the Python reference implementation.
%
%   Property names in the specification are the schema names. A value
%   object with a $-key is resolved here: $ref links another node of the
%   collection by key, $instance links a controlled instance by IRI,
%   $embedded holds an embedded instance, $date and $datetime hold ISO
%   8601 text.
%
%   Input Arguments:
%     specPath - Path to the JSON specification.
%
%   Output Arguments:
%     collection - openminds.Collection holding the nodes in spec order.
%
%   See also tools/tests/interop/openminds_interop.py

    arguments
        specPath (1,1) string {mustBeFile}
    end

    typeIRIBase = "https://openminds.om-i.org/types/";

    spec = jsondecode(openminds.internal.utility.readUtf8File(specPath));

    % containers.Map rather than dictionary, which R2022a does not have
    nodesByKey = containers.Map('KeyType', 'char', 'ValueType', 'any');
    nodes = cell(1, numel(spec.nodes));

    for i = 1:numel(spec.nodes)
        node = spec.nodes(i);
        nodes{i} = instantiate(node.type, node.properties);
        nodesByKey(node.key) = nodes{i};
    end

    collection = openminds.Collection(nodes{:});

    function instance = instantiate(typeName, properties)
        typeEnum = openminds.enum.Types.fromAtType(typeIRIBase + typeName);

        propertyNames = string(fieldnames(properties))';
        nameValuePairs = cell(1, 2*numel(propertyNames));
        for j = 1:numel(propertyNames)
            nameValuePairs{2*j-1} = propertyNames(j);
            nameValuePairs{2*j} = resolve(properties.(propertyNames(j)));
        end

        instance = feval(typeEnum.ClassName, nameValuePairs{:});
    end

    function value = resolve(value)
        % jsondecode gives a cell for a list of unlike items and a struct
        % array for a list of like objects
        if iscell(value)
            value = cellfun(@resolve, value, 'UniformOutput', false);
            value = concatenateIfAlike(value);
        elseif isstruct(value) && ~isscalar(value)
            value = arrayfun(@resolve, value, 'UniformOutput', false);
            value = concatenateIfAlike(value);
        elseif isstruct(value)
            value = resolveValueObject(value);
        end
    end

    function value = resolveValueObject(object)
        % jsondecode turns "$ref" into the field name "x_ref"
        if isfield(object, 'x_ref')
            value = nodesByKey(char(object.x_ref));
        elseif isfield(object, 'x_instance')
            value = openminds.instanceFromIRI(string(object.x_instance));
        elseif isfield(object, 'x_embedded')
            value = instantiate(string(object.x_embedded), object.properties);
        elseif isfield(object, 'x_date')
            value = openminds.internal.utility.parseIsoDateTime(string(object.x_date));
        elseif isfield(object, 'x_datetime')
            value = openminds.internal.utility.parseIsoDateTime(string(object.x_datetime));
        else
            error('ommtest:buildInteropCollection:UnknownValueObject', ...
                'Unknown value object with fields: %s', strjoin(fieldnames(object), ', '))
        end
    end

    function values = concatenateIfAlike(values)
        % Instances of one class concatenate to an object array; a mix of
        % classes stays a cell, which a mixed-type property accepts
        classNames = cellfun(@class, values, 'UniformOutput', false);
        if isscalar(unique(classNames))
            values = [values{:}];
        end
    end
end
