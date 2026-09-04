function text = readUtf8File(filePath)
%readUtf8File Read a whole file as UTF-8 text
%
%   text = openminds.internal.utility.readUtf8File(filePath) returns the
%   content of the file as a string scalar, decoded as UTF-8. A byte order
%   mark is dropped.
%
%   The bytes are decoded explicitly. The text readers (fileread, fread
%   with a char precision, readlines) decode a character outside the Basic
%   Multilingual Plane, such as an emoji, to the substitute character
%   U+001A (observed on R2025b), so text holding such a character would be
%   silently altered.
%
%   See also openminds.internal.utility.filewrite

    arguments
        filePath (1,1) string {mustBeFile}
    end

    fileId = fopen(filePath, 'r');
    if fileId < 0
        error('openMINDS:ReadUtf8File:FileNotReadable', ...
            'Could not open file "%s" for reading.', filePath)
    end
    fileCleanup = onCleanup(@() fclose(fileId));

    bytes = fread(fileId, '*uint8')';
    text = string(native2unicode(bytes, 'UTF-8'));

    byteOrderMark = char(65279); % U+FEFF
    if startsWith(text, byteOrderMark)
        text = extractAfter(text, 1);
    end
end
