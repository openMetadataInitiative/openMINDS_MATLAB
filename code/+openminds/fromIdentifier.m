function instance = fromIdentifier(atId)
    [type, name] = openminds.utility.parseAtID(atId);
    enumType = openminds.enum.Types(type);
    instance = feval(enumType.ClassName, name);
end
