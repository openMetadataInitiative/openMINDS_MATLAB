function structInstance = jsonld2struct(jsonInstance)
%Convert metadata instance(s) from JSON-LD text strings to struct arrays
%
%   See also openminds.internal.serializer.struct2jsonld

    vocabBaseUri = "https://openminds.ebrains.eu/vocab/";

    jsonInstance = strrep(jsonInstance, vocabBaseUri, '');
    structInstance = openminds.internal.utility.json.decode(jsonInstance);

    if isfield(structInstance, 'at_graph')
        structInstance = structInstance.at_graph;
    end
end
