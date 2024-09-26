function versionNumber = validateVersionNumber(versionNumber)
%validateVersionNumber Check that version number is a valid openMINDS version
    
    arguments
        versionNumber (1,1) string
    end

    % - Validate inputs
    if versionNumber == "latest"
        versionNumber = string(openminds.internal.constants.Models.getLatestVersionNumber());
    end
    
    % Todo: More specific error message
    versionNumber = validatestring(versionNumber, string(openminds.internal.constants.Models.VERSION_NUMBERS));
