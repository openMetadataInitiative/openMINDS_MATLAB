function url = VocabURL(vocabType)
    arguments
        vocabType (1,1) om.internal.vocab.enum.VocabType = "types"
    end
    
    url = sprintf( "https://raw.githubusercontent.com/openMetadataInitiative/openMINDS/main/vocab/%s", vocabType.FileName);
end