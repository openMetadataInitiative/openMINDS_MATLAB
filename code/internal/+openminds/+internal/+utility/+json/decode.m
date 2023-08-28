function s = decode(str)
    
    %str = strrep(str, '@', 'at_');
    s = jsondecode(str);

    % Find any property names starting with @ 
    names = regexp(str, '\@\w*(?=\")', 'match' );
    oldNames = strrep(names, '@', 'x_');
    newNames = strrep(names, '@', 'at_');
    
    if iscell(s)
        s = cellfun(@(c) fieldnamerep(c, oldNames, newNames), s, 'UniformOutput', 0);
    else
        s = fieldnamerep(s, oldNames, newNames);
    end
end

function S = fieldnamerep(S, oldNames, newNames)
    
    allFieldNames = fieldnames(S);
    
    [~, iA] = intersect(oldNames, allFieldNames );
    if iscolumn(iA); iA = transpose(iA); end
    
    for i = iA
        if isfield(S, oldNames{i})
            for j = 1:numel(S)
                S(j).(newNames{i}) = S(j).(oldNames{i});
            end
        end
    end

    S = rmfield(S, oldNames(iA));
    
    allFieldNamesNew = allFieldNames;
    for i = iA
        allFieldNamesNew = strrep(allFieldNamesNew, oldNames{i}, newNames{i});
    end
    
    S = orderfields(S, allFieldNamesNew);

    for i = 1:numel(S)
        isStruct = structfun(@isstruct, S(i));
        if iscolumn(isStruct); isStruct = transpose(isStruct); end
        
        for j = find(isStruct)
            S(i).(allFieldNamesNew{j}) = fieldnamerep(S(i).(allFieldNamesNew{j}), oldNames, newNames);
        end
    end
end