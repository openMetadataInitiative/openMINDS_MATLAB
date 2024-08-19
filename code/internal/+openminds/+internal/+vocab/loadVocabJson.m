function S = loadVocabJson(name)
% loadVocabJson - Load vocab for given name to struct from json file     
    arguments
        name (1,1) om.internal.vocab.enum.VocabType = "types"
    end

    if ~isfile(om.internal.vocab.constants.VocabFilepath(name))
        om.internal.vocab.downloadVocabFiles()
    end

    jsonStr = fileread( om.internal.vocab.constants.VocabFilepath(name) );
    S = jsondecode(jsonStr);
end
