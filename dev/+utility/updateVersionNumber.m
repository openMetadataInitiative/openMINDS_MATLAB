function newVersion = updateVersionNumber(previousVersion, releaseType, versionString, options)
% updateVersionNumber - Utility function to update a version number
%
% Adapted from: https://github.com/mathworks/climatedatastore/blob/main/buildUtilities/packageToolbox.m
    
    arguments
        previousVersion string {mustBeTextScalar} = "";
        releaseType {mustBeTextScalar,mustBeMember(releaseType,["build","major","minor","patch","specific"])} = "build"
        versionString {mustBeTextScalar} = "";
        options.IncludeBuildNumber (1,1) logical = true
    end

    pat = digitsPattern;
    versionParts = extract(previousVersion, pat);
    if numel(versionParts) == 1 % Using numel == 1 for symmetry
        versionParts(2) = "0";
    end
    if numel(versionParts) == 2
        versionParts(3) = "0";
    end
    if numel(versionParts) == 3
        versionParts(4) = "0";
    end
    
    switch lower(releaseType)
        case "major"
            versionParts(1) = string(str2double(versionParts(1)) + 1);
            versionParts(2) = "0";
            versionParts(3) = "0";
        case "minor"
            versionParts(2) = string(str2double(versionParts(2)) + 1);
            versionParts(3) = "0";
        case "patch"
            versionParts(3) = string(str2double(versionParts(3)) + 1);
        case "specific"        
            if startsWith(versionString, "v")
                % if there's a "v" at the front, which is common in github, remove it
                versionString = extractAfter(versionString, 1);
            end
            newVersionParts = extract(versionString, pat);
            if any(size(newVersionParts) ~= [3 1])
                error("releaseToolbox:versionMustBe3part", ...
                    "VersionString must be a 3 part semantic version (i.e. ""1.2.3"").")
            end
            versionParts(1) = newVersionParts(1);
            versionParts(2) = newVersionParts(2);
            versionParts(3) = newVersionParts(3);
    end
    % Always increment the build number
    versionParts(4) = string(str2double(versionParts(4)) + 1);
    if ~options.IncludeBuildNumber
        versionParts = versionParts(1:3);
    end
    newVersion = join(versionParts, ".");
end
