function mustBeListOfUniqueItems(value)
    % Handle case where value might be an array of mixed types.
    if openminds.utility.isMixedInstance(value)
        value = arrayfun(@(v) v.Instance, value, 'uni', 0);
        instanceTypes = cellfun(@(v) class(v), value, 'UniformOutput', 0);
        uniqueInstanceTypes = unique(instanceTypes);
        for instanceType = uniqueInstanceTypes
            isOfType = strcmp( instanceTypes, instanceType );
            valuesOfType = [value{isOfType}];

            if isstruct(valuesOfType) % Instance is a struct with id, i.e unresolved link
                assert(isfield(valuesOfType, 'id'), ...
                    'OPENMINDS_MATLAB:PropertyValidator:InvalidMixedTypeInstance', ...
                    'Expected an unresolved reference of a mixed type instance to be a structure with an "id" field.')
                valuesOfType = {valuesOfType.id};
            end
            assert( isequal(valuesOfType, unique(valuesOfType, 'stable')), ...
                'OPENMINDS_MATLAB:PropertyValidator:MixedTypeInstancesMustBeUnique', ...
                'Property value must be an array of unique items' );
        end
    else
        assert( isequaln( sort(value), unique(value)), ...
            'OPENMINDS_MATLAB:PropertyValidator:ValuesMustBeUnique', ...
            'Property value must be an array of unique items' );
    end
end

% Todo: For instances, should use identifiers and not object equality
