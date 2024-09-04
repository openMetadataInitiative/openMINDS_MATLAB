classdef Models < handle
    
    properties (Constant)
        VOCAB_IRI = "https://openminds.ebrains.eu/vocab/"
        VERSION_NUMBERS = [1, 2, 3, 4];
    end

    methods (Static)
        function versionNumber = getLatestVersionNumber()
            versionNumber = openminds.internal.constants.Models.VERSION_NUMBERS(end);
        end
    end
end
