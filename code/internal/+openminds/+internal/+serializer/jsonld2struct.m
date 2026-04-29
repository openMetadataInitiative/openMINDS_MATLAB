function structInstance = jsonld2struct(jsonInstance)
%Convert metadata instance(s) from JSON-LD text strings to struct arrays

    vocabBaseUri = [
        "https://openminds.ebrains.eu/vocab/"
        "https://openminds.om-i.org/props/"
    ];

    for i = 1:numel(vocabBaseUri)
        propertyKeyPattern = sprintf('"%s([^"]+)"\\s*:', ...
            regexptranslate('escape', vocabBaseUri(i)));
        jsonInstance = regexprep(jsonInstance, propertyKeyPattern, '"$1":');
    end
    structInstance = openminds.internal.utility.json.decode(jsonInstance);

    if isfield(structInstance, 'at_graph')
        structInstance = structInstance.at_graph;
    end
end
