function filePath = VocabFilepath(vocabType)
    arguments
        vocabType (1,1) om.internal.vocab.enum.VocabType = "types"
    end
    
    saveFolder = fullfile(openminds.internal.rootpath, 'resources', '.vocab');
    filePath = fullfile(saveFolder, vocabType.FileName);
end