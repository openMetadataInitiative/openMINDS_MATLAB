function S = loadVocabJson(name)
% loadVocabJson - Load "vocab" json file for given name to struct
%
%   The central openMINDS repository has a set of "vocab" json files to
%   list meta-information about categories, properties and types for all
%   the openMINDS metadata models and versions.
%
%   See also:   openminds.internal.vocab.enum.VocabType        <-- Available-types
%               openminds.internal.vocab.downloadVocabFiles    <-- Download-vocab-files

    arguments
        name (1,1) openminds.internal.vocab.enum.VocabType = "types"
    end

    if ~isfile(openminds.internal.vocab.constants.VocabFilepath(name))
        openminds.internal.vocab.downloadVocabFiles()
    end

    jsonStr = fileread( openminds.internal.vocab.constants.VocabFilepath(name) );
    S = jsondecode(jsonStr);
end
