function mustBeInstanceOrEmpty(value)
    if ~isempty(value)
        mustBeA(value, 'openminds.Node');
    end
end
