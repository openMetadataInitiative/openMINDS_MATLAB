function [toolboxInfo, identifier] = readToolboxInfo()
% readToolboxInfo - Read toolbox info from MLToolboxInfo.json
%
%   Assumes an MLToolboxInfo.json file is present in <PackageRootDir>/dev

    projectRootDir = ommtools.getProjectRootDir();
    toolboxInfoFilePath = fullfile(projectRootDir, "dev", "MLToolboxInfo.json");
    toolboxInfo = jsondecode(fileread(toolboxInfoFilePath));

    if nargout == 2
        % Get toolbox identifier and remove it from toolbox info
        identifier = toolboxInfo.Identifier; 
        toolboxInfo = rmfield(toolboxInfo, 'Identifier');
    end
end
