function validVersions = listModelVersions()
% listModelVersions - Versions of the openMINDS model this toolbox has type classes for

    typesFolder = openminds.internal.constants.Paths.TypesFolder;
    L = dir(typesFolder);
    L(startsWith({L.name}, '.') | ~[L.isdir]) = [];
    validVersions = cellstr({L.name});
end
