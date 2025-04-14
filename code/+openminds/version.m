function versionStr = version(version)
% version - Set or get the version for the currently active openMINDS metadata model
%
% Syntax:
%   versionStr = openminds.version() returns the version string of the currently active
%       version of the openMINDS metadata model
%
%   openminds.version(versionSpec) changes the currently active version of the
%       openMINDS metadata model to the provided version
%
% Input Arguments:
%   version (numeric or string) -
%    The version number to set for the openMINDS metadata model. If this
%    argument is missing, the current version will be retrieved.
%
% Output Arguments:
%   versionStr - A string representing the current or newly set version
%   of the openMINDS metadata model.

    arguments
        version (1,1) openminds.internal.utility.VersionNumber ...
            {openminds.mustBeValidVersion(version)} = missing
    end
    if ismissing(version)
        versionStr = string(openminds.getModelVersion());
    else
        openminds.selectOpenMindsVersion(version)
        versionStr = string(version);
    end
end
