function vocabularyIRIs = getVocabularyIRIs()
%getVocabularyIRIs Vocabulary IRIs used by any openMINDS model version
%
%   vocabularyIRIs = getVocabularyIRIs() returns every vocabulary IRI an
%   openMINDS document may use for property names in expanded form.
%
%   Documents are read regardless of which model version wrote them, so
%   all known vocabularies are needed, not only the one belonging to the
%   active version.

    vocabularyIRIs = [ ...
        openminds.constant.BaseURI("v1") + "/vocab/", ...
        openminds.constant.BaseURI("v4") + "/props/"];
end
