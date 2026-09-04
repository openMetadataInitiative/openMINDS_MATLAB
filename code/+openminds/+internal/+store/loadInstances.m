function instances = loadInstances(filePath)
%loadInstances Load metadata instances from one or more files
%
%   instances = loadInstances(filePath) reads the given files and returns
%   a cell array of openMINDS instances, with the references between them
%   resolved to the instances themselves.
%
%   The format is chosen from the file extension. Parsing, type dispatch
%   and link wiring are the deserializer's work; this function only reads
%   the files and picks the deserializer.
%
%   Input Arguments:
%     filePath - One or more paths to metadata files.
%
%   Output Arguments:
%     instances - Cell array of openminds.Node instances.
%
%   See also openminds.internal.serializer.JsonLdDeserializer

    arguments
        filePath (1,:) string = string.empty
    end

    instances = {};
    if isempty(filePath)
        return
    end

    deserializer = selectDeserializer(filePath(1));

    documents = arrayfun(@openminds.internal.utility.readUtf8File, filePath);
    instances = deserializer.deserialize(documents);
end

function deserializer = selectDeserializer(filePath)
% Pick a deserializer from the file extension.

    [~, ~, fileExtension] = fileparts(filePath);

    switch lower(fileExtension)
        case ".jsonld"
            deserializer = openminds.internal.serializer.JsonLdDeserializer();
        otherwise
            error('openMINDS:LoadInstances:UnsupportedFormat', ...
                ['Unsupported metadata file format "%s". ', ...
                'Supported formats: .jsonld'], fileExtension)
    end
end
