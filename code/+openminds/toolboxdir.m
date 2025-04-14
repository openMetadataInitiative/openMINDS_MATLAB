function folderPath = toolboxdir()
% Root folder for the openMINDS_MATLAB toolbox
%
%    folderPath = openminds.toolboxdir() returns a character vector that is the
%       absolute path to the root of the toolbox folder

    folderPath = fileparts(fileparts(mfilename('fullpath')));
    assert(isfolder(folderPath), 'Toolbox folder does not exist') % Should not happen
end
