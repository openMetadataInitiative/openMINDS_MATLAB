function writeBadgeJSONFile(label, message, color, options)
% writeBadgeJSONFile Create and save a JSON file representing a badge/shield.
%
%   writeBadgeJSONFile(label, message, color) creates a JSON file in the 
%       "docs/reports/badge" directory that describes a badge using the 
%       specified label, message, and color. The JSON file is created with a 
%       name derived from the label, with spaces replaced by underscores.
%
%   Arguments:
%       label  (string) - The label for the badge. This string will be used as 
%                         part of the JSON data and as the filename (spaces 
%                         replaced by underscores).
%
%       message (string) - The message to display on the badge. This string is 
%                          included in the JSON data under the "message" field.
%
%       color  (string) - The color of the badge. Must be one of the following: 
%                         "red", "green", "blue", "orange", or "yellow". This 
%                         string is included in the JSON data under the "color" 
%                         field.
%   
%   Optional name/value arguments:
%       OutputFolder - Path for folder to save badge
%
%       FileName - Name of file excluding extension
%
%   Example:
%
%   writeBadgeJSONFile("Test Coverage", "90%", "green") creates a file 
%       named "Test_Coverage.json" in the "docs/reports/badge" directory that 
%       represents a green badge with the label "Test Coverage" and the message "90%".
%
%   The function checks if the output directory exists, and creates it if 
%   necessary. The badge information is encoded as a JSON string and written 
%   to a file in the specified directory.
%
%   CREDIT: https://github.com/mathworks/climatedatastore/tree/main/buildUtilities

    arguments
        label (1,1) string
        message (1,1) string
        color (1,1) string {mustBeMember(color, ["red","green","blue","orange","yellow"])}
        options.OutputFolder (1,1) string = fullfile(ommtools.getProjectRootDir(), "docs", "reports", "badge");
        options.FileName (1,1) string = missing
    end

    if ~isfolder(options.OutputFolder)
        mkdir(options.OutputFolder)
    end

    badgeInfo = struct;
    badgeInfo.schemaVersion = 1;
    badgeInfo.label = label;
    badgeInfo.message = message;
    badgeInfo.color = color;
    badgeJSON = jsonencode(badgeInfo);
    
    if ismissing(options.FileName)
        name = strrep(label, " ", "_");
    else
        name = options.FileName;
    end
    fid = fopen(fullfile(options.OutputFolder, name + ".json"), "w");
    try
        fwrite(fid, badgeJSON);
    catch e
        fclose(fid);
        rethrow e
    end
    fclose(fid);
    fprintf('Saved badge to %s\n', fullfile(options.OutputFolder, name + ".json"))
end
