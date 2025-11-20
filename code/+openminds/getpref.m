function pref = getpref(preferenceName)
% getpref - Retrieve a specific user preference.
%
% Syntax:
%   pref = openminds.getpref() returns an object representing the user
%   preferences for the openMINDS Metadata Toolbox
%
%   pref = openminds.getpref(preferenceName) Retrieves the value of the
%   specified user preference from the Preferences.
%
% Input Arguments:
%   preferenceName (1,1) string - The name of the preference to retrieve.
%
% Output Arguments:
%   pref - The value of the specified preference.

    arguments
        preferenceName (1,1) string ...
            {mustBeMember(preferenceName, ...
                [ ...
                    "PropertyDisplayMode", ...
                    "DocLinkTarget", ...
                    "AddControlledInstanceToCollection", ...
                    "" ...
                ])...
            } = ""
    end

    pref = openminds.utility.Preferences.getSingleton;

    if preferenceName ~= ""
        pref = pref.(preferenceName);
    end
end
