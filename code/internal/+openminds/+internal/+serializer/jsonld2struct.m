function structInstance = jsonld2struct(jsonInstance)
%jsonld2struct Convert JSON-LD text into struct form
%
%   structInstance = jsonld2struct(jsonInstance) decodes one JSON-LD
%   document. A collection document is returned as its @graph, so the
%   result is always the nodes rather than the wrapper.
%
%   Property names written in expanded form carry a vocabulary IRI. That
%   prefix is removed so the field names match the property names of the
%   generated type classes. Every openMINDS vocabulary is removed, not
%   just the one belonging to the active model version, so a document
%   written for an older model can still be read.

    arguments
        jsonInstance (1,1) string
    end

    for vocabularyIRI = openminds.internal.serializer.jsonld.getVocabularyIRIs()
        jsonInstance = strrep(jsonInstance, vocabularyIRI, "");
    end

    structInstance = openminds.internal.utility.json.decode(jsonInstance);

    if isfield(structInstance, 'at_graph')
        structInstance = structInstance.at_graph;
    end
end
