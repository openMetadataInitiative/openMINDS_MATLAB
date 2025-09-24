function tempStore = createTemporaryStore(savePath)
% createTemporaryStore - Create a temporary store given a filepath

% Todo: Infer serializer from file extension.
%   If folder? optional format input?

    [~, ~, fileExtension] = fileparts(savePath);
    
    if ~isempty(char(fileExtension))
        tempStore = openminds.internal.FileMetadataStore(savePath);
    else
        tempStore = openminds.internal.FolderMetadataStore(savePath);
    end
end
