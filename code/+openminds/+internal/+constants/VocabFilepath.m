function filePath = VocabFilepath(vocabType)
    arguments
        vocabType (1,1) openminds.internal.vocab.enum.VocabType = "types"
    end
    
    saveFolder = fullfile(openminds.toolboxdir(), 'resources', '.vocab');
    filePath = fullfile(saveFolder, vocabType.FileName);
end
