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
            elseif isstruct(valuesOfType) % Instance is a struct with id, i.e unresolved link
                if isfield(valuesOfType, 'id')
                    valuesOfType = {valuesOfType.id};
                else
                    throw(InvalidTypeError)
                end
            end
            assert( isequal(valuesOfType, unique(valuesOfType, 'stable')), 'Value must be an array of unique items' );
        end
    else
        assert( isequaln( sort(value), unique(value)), 'Value must contain unique items' );
    end
end

function ME = InvalidTypeError()
    ME = MException("OPENMINDS:InvalidValueType", "Value type is unexpected");
end