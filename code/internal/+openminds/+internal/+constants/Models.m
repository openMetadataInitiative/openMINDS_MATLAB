classdef Models < handle
    
    properties (Constant)
        VERSION_NUMBERS = [1, 2, 3];
    end

    methods (Static)
        function versionNumber = getLatestVersionNumber()
            versionNumber = openminds.internal.constants.Models.VERSION_NUMBERS(end);
        end
    end
end