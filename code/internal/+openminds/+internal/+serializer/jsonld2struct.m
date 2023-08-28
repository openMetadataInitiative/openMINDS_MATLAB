function structInstance = jsonld2struct(jsonInstance)

    vocabBaseUri = "https://openminds.ebrains.eu/vocab/";

    jsonInstance = strrep(jsonInstance, vocabBaseUri, '');
    structInstance = openminds.internal.utility.json.decode(jsonInstance);
end