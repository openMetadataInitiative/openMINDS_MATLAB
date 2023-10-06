function jsonInstance = struct2jsonld(structInstance)
%Convert a metadata instance from a struct to a JSON-LD text string.
%
%   jsonInstance = struct2jsonld(structInstance) converts a MATLAB struct
%   instance into a JSON-LD (JavaScript Object Notation for Linked Data)
%   text string. JSON-LD is a lightweight data interchange format that
%   is easy for humans to read and write and easy for machines to parse
%   and generate.
%
%   Parameters:
%       - structInstance: A MATLAB struct array containing metadata
%                         instances to be converted to JSON-LD.
%
%   Returns:
%       - jsonInstance: A JSON-LD formatted text string representing
%                       the provided metadata instances. If structInstance
%                       is an array, jsonInstance is a cell array with the
%                       same size.

    vocabBaseUri = "https://openminds.ebrains.eu/vocab/";
    
    if numel(structInstance) > 1
        structInstance = struct( ...
            'at_context', {struct('at_vocab', vocabBaseUri)}, ...
            'at_graph', {structInstance} ...
        );
    end

    jsonStr = openminds.internal.utility.json.encode(structInstance);
    jsonInstance = strrep(jsonStr, 'VOCAB_URI_', vocabBaseUri);
end
