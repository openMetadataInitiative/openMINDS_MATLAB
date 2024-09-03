function S = loadVocabJson(name)
% loadVocabJson - Load "vocab" json file for given name to struct
%
%   The central openMINDS repository has a set of "vocab" json files to
%   list meta-information about categories, properties and types for all
%   the openMINDS metadata models and versions.
%
%   See also:   om.internal.vocab.enum.VocabType        <-- Available-types
%               om.internal.vocab.downloadVocabFiles    <-- Download-vocab-files

    arguments
        name (1,1) om.internal.vocab.enum.VocabType = "types"
    end

    if ~isfile(om.internal.vocab.constants.VocabFilepath(name))
        om.internal.vocab.downloadVocabFiles()
    end

    jsonStr = fileread( om.internal.vocab.constants.VocabFilepath(name) );
    S = jsondecode(jsonStr);
end
