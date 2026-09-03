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
%     instances - Cell array of openminds.abstract.Schema instances.
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

    documents = arrayfun(@readDocument, filePath);
    instances = deserializer.deserialize(documents);
end

function document = readDocument(filePath)
% Read a file as UTF-8 text.
%
% The bytes are decoded explicitly. The text readers (fileread, fread with
% a char precision, readlines) decode a character outside the Basic
% Multilingual Plane, such as an emoji, to the substitute character U+001A
% (observed on R2025b), so metadata holding such characters would be
% silently altered.

    fileId = fopen(filePath, 'r');
    if fileId < 0
        error('openMINDS:LoadInstances:FileNotReadable', ...
            'Could not open file "%s" for reading.', filePath)
    end
    fileCleanup = onCleanup(@() fclose(fileId));

    bytes = fread(fileId, '*uint8')';
    document = string(native2unicode(bytes, 'UTF-8'));

    % A byte order mark is not part of the document
    byteOrderMark = char(65279); % U+FEFF
    if startsWith(document, byteOrderMark)
        document = extractAfter(document, 1);
    end
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
