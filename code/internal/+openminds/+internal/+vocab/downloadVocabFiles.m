function downloadVocabFiles()
% downloadVocabFiles - Download openminds vocab files

    typesUrl = openminds.internal.constants.VocabURL("TYPES");
    propsUrl = openminds.internal.constants.VocabURL("PROPERTIES");

    saveFolder = fileparts(openminds.internal.constants.VocabFilepath);
    if ~isfolder(saveFolder); mkdir(saveFolder); end

    websave(openminds.internal.constants.VocabFilepath("TYPES"), typesUrl);
    websave(openminds.internal.constants.VocabFilepath("PROPERTIES"), propsUrl);
end
