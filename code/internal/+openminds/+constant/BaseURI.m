function baseURI = BaseURI(version)
% BaseURI Get the base URI for the specified OpenMINDS schema version
%
%   baseURI = openminds.constant.BaseURI(version) returns the base URI as a
%   string that corresponds to the base resource identifier for the specified
%   OpenMINDS model version. This function dynamically selects the URI based on 
%   the version input. If no version is specified, the version number of the 
%   currently active openMINDS model is selected.
%
%   Input:
%       version - (optional) An instance of openminds.internal.utility.VersionNumber
%                 specifying the model version. If no version is provided,
%                 the function automatically retrieves the current model
%                 version using openminds.getModelVersion.
%
%   Output:
%       baseURI - A string containing the base URI corresponding to the
%                 specified or default schema version.
%
%   Conditions:
%       - Versions <= 3 return "https://openminds.ebrains.eu"
%       - Versions >= 4 return "https://openminds.om-i.org"
%
%   Example:
%       baseURI = openminds.constant.BaseURI(3);  % Returns "https://openminds.ebrains.eu"
%       baseURI = openminds.constant.BaseURI(4);  % Returns "https://openminds.om-i.org"
%
%   See also: openminds.getModelVersion

    arguments
        version (1,1) openminds.internal.utility.VersionNumber ...
            {openminds.mustBeValidVersion(version)} = missing
    end

    if ismissing(version)
        version = openminds.getModelVersion("VersionNumber");
    end

    if version <= 3
        baseURI = "https://openminds.ebrains.eu";
    elseif version >= 4
        baseURI = "https://openminds.om-i.org";
    end
end
