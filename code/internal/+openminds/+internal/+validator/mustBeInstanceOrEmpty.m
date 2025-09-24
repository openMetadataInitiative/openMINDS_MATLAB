function mustBeInstanceOrEmpty(value)
    if ~isempty(value)
        mustBeA(value, 'openminds.abstract.Schema');
    end
end
