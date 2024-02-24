function mustBeListOfUniqueItems(value)
    % Handle case where value might be an array of mixed types.
    if isa(value, 'openminds.internal.abstract.LinkedCategory')
        value = arrayfun(@(v) v.Instance, value, 'uni', 0);
        instanceTypes = cellfun(@(v) class(v), value, 'UniformOutput', 0);
        uniqueInstanceTypes = unique(instanceTypes);
        for instanceType = uniqueInstanceTypes
            isOfType = contains( instanceTypes, instanceType );
            valuesOfType = [value{isOfType}];
            if ischar(valuesOfType)
                valuesOfType = string(valuesOfType);
            end
            assert( isequal(valuesOfType, unique(valuesOfType, 'stable')), 'Value must be an array unique items' );
        end
    else
        assert( isequaln( sort(value), unique(value)), 'Value must contain unique items' );
    end
end
