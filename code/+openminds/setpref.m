function pref = setpref(prefValues)
% setpref - Sets preferences from the provided preference values.
%
% Syntax:
%   pref = openminds.setpref(Name, Value, ...)
%
% Input Arguments:
%   Name value pairs for preferences:
%       - Name  - Name of a preference
%       - Value - The new value of a preference
%
% Output Arguments:
%   pref - An instance of openminds.utility.Preferences after applying
%          the provided preference values.

    arguments
        prefValues.?openminds.utility.Preferences
    end

    pref = openminds.utility.Preferences.getSingleton;

    prefNames = fieldnames(prefValues);
    for i = 1:numel(prefNames)
        preferenceName = prefNames{i};
        pref.(preferenceName) = prefValues.(preferenceName);
    end
end
