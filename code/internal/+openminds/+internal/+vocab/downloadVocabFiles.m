function downloadVocabFiles()
% downloadVocabFiles - Download openminds vocab files

    typesUrl = openminds.internal.vocab.constants.VocabURL("TYPES");
    propsUrl = openminds.internal.vocab.constants.VocabURL("PROPERTIES");

    saveFolder = fileparts(openminds.internal.vocab.constants.VocabFilepath);
    if ~isfolder(saveFolder); mkdir(saveFolder); end

    websave(openminds.internal.vocab.constants.VocabFilepath("TYPES"), typesUrl);
    websave(openminds.internal.vocab.constants.VocabFilepath("PROPERTIES"), propsUrl);
end