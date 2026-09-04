function baseIRI = BaseIRI(version)
% BaseIRI Get the base IRI for the specified OpenMINDS schema version
%
%   baseIRI = openminds.constant.BaseIRI(version) returns the base IRI as a
%   string that corresponds to the base resource identifier for the specified
%   OpenMINDS model version. This function dynamically selects the IRI based on
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
%       baseIRI - A string containing the base IRI corresponding to the
%                 specified or default schema version.
%
%   Conditions:
%       - Versions <= 3 return "https://openminds.ebrains.eu"
%       - Versions >= 4 return "https://openminds.om-i.org"
%
%   Example:
%       baseIRI = openminds.constant.BaseIRI(3);  % Returns "https://openminds.ebrains.eu"
%       baseIRI = openminds.constant.BaseIRI(4);  % Returns "https://openminds.om-i.org"
%
%   See also: openminds.getModelVersion

    arguments
        version (1,1) openminds.internal.utility.VersionNumber ...
            {openminds.mustBeValidModelVersion(version)} = missing
    end

    if ismissing(version)
        version = openminds.getModelVersion("VersionNumber");
    end

    if version <= 3
        baseIRI = "https://openminds.ebrains.eu";
    elseif version >= 4
        baseIRI = "https://openminds.om-i.org";
    end
end
