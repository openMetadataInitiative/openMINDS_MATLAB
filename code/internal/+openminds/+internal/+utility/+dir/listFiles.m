function [filePath, filename] = listFiles(filePathCellArray, filetype)

    narginchk(1,2)

    if nargin < 2
        filetype = '';
    end
    
    [filePath, filename] = deal([]);

    if ~isa(filePathCellArray, 'cell')
        filePathCellArray = {filePathCellArray};
    end

    L = cell(1, numel(filePathCellArray));
    
    for i = 1:numel(filePathCellArray)
        
        thisL = dir(filePathCellArray{i});
        thisL = thisL(~[thisL.isdir]);

        L{i} = thisL;
    end
    L = cat(1, L{:});

    if isempty(L)
        return
    end

    keep = ~ strncmp({L.name}, '.', 1);
    L = L(keep);
    
    if ~strncmp(filetype, '.', 1)
        filetype = strcat('.', filetype);
    end

    if ~isempty(filetype) % Filter by filetype...
        [~, ~, ext] = fileparts({L.name});
        keep = strcmp(ext, filetype);
        L = L(keep);
    end
    
    filePath = fullfile({L.folder}, {L.name});
    if isrow(filePath); filePath = filePath'; end
    
    if nargout == 2
        filename = {L.name};
    end
end

% % function [folders, names, ext] = fileparts(varargin)
% %
% %     [folders, names, ext] = deal(cell(1, numel(varargin)));
% %
% %     for i = 1:numel(varargin)
% %         [folders{i}, names{i}, ext{i}] = builtin('fileparts', varargin{i});
% %     end
% %
% %     if nargin == 1
% %         folders = folders{1}; names = names{1}; ext = ext{1};
% %     end
% %
% %     if nargout == 1
% %         clear names ext
% %     elseif nargout == 2
% %         clear ext
% %     end
% %
% % end
