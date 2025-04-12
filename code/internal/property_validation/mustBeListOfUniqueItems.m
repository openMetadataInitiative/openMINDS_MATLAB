function mustBeListOfUniqueItems(value)
% mustBeListOfUniqueItems - Validate that the input is a list of unique items
%
% Syntax:
%   mustBeListOfUniqueItems(value)
%
% Input Arguments:
%   value - The input to be validated; can be an array of typed instances,
%           strings or other native data types.
%
% Note: If input is a list of typed metadata instances, equality is
% determined by comparing the identifiers of the instances.

    if isempty(value); return; end

    if openminds.utility.isMixedInstance(value)
        value = arrayfun(@(v) v.Instance, value, 'uni', 0);
        instanceTypes = cellfun(@(v) class(v), value, 'UniformOutput', 0);
        uniqueInstanceTypes = unique(instanceTypes);
        
        for instanceType = uniqueInstanceTypes
            isOfThisType = strcmp(instanceTypes, instanceType);
            valuesOfThisType = [value{isOfThisType}];

            if isstruct(valuesOfThisType) % Instance is a struct with id, i.e unresolved link
                assertValidMixedTypeReference(valuesOfThisType)
            end
            assertUniqueInstances(valuesOfThisType)
        end

    elseif openminds.utility.isInstance(value)
        assertUniqueInstances(value)

    else % Any other data type
        assertUniqueValues(value)
    end
end

function assertValidMixedTypeReference(structure)
    assert(isfield(structure, 'id'), ...
        'OPENMINDS_MATLAB:PropertyValidator:InvalidMixedTypeReference', ...
        ['Expected an unresolved reference of a mixed type instance ', ...
        'to be a structure with an "id" field.'])
end

function assertUniqueInstances(instances)
    instanceIdentifiers = {instances.id};
    assert(isequal(instanceIdentifiers, unique(instanceIdentifiers, 'stable')), ...
        'OPENMINDS_MATLAB:PropertyValidator:InstancesMustBeUnique', ...
        'Value must be an array of unique instances');
end

function assertUniqueValues(values)
    assert(isequaln(sort(values), unique(values)), ...
        'OPENMINDS_MATLAB:PropertyValidator:ValuesMustBeUnique', ...
        'Value must be an array of unique elements');
end
