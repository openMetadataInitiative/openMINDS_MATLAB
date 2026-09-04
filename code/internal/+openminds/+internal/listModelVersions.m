function validVersions = listModelVersions()
% listModelVersions - Versions of the openMINDS model this toolbox has type classes for

    generatedFolder = openminds.internal.constants.Paths.GeneratedFolder;
    L = dir(generatedFolder);
    L(startsWith({L.name}, '.') | ~[L.isdir]) = [];
    validVersions = cellstr({L.name});
end
