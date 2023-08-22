function s = decode(str)
    
    %str = strrep(str, '@', 'at_');
    s = jsondecode(str);

    % Find any property names starting with @ 
    names = regexp(str, '\@\w*(?=\")', 'match' );
    oldNames = strrep(names, '@', 'x_');
    newNames = strrep(names, '@', 'at_');

    s = fieldnamerep(s, oldNames, newNames);
end

function S = fieldnamerep(S, oldNames, newNames)
    
    allFieldNames = fieldnames(S);
    
    [~, iA] = intersect(oldNames, allFieldNames );
    if iscolumn(iA); iA = transpose(iA); end
    
    for i = iA
        if isfield(S, oldNames{i})
            S.(newNames{i}) = S.(oldNames{i});
        end
    end

    S = rmfield(S, oldNames(iA));
    
    allFieldNamesNew = allFieldNames;
    for i = iA
        allFieldNamesNew = strrep(allFieldNamesNew, oldNames{i}, newNames{i});
    end
    
    S = orderfields(S, allFieldNamesNew);

    isStruct = structfun(@isstruct, S);
    if iscolumn(isStruct); isStruct = transpose(isStruct); end
    
    for i = find(isStruct)
        S.(allFieldNamesNew{i}) = fieldnamerep(S.(allFieldNamesNew{i}), oldNames, newNames);
    end
end