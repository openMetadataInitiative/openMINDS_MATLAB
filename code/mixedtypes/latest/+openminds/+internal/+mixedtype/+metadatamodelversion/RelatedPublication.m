classdef RelatedPublication < openminds.internal.abstract.LinkedCategory
    properties (Constant, Hidden)
        ALLOWED_TYPES = ["openminds.core.DOI", "openminds.core.HANDLE", "openminds.core.ISBN", "openminds.core.ISSN", "openminds.publications.Book", "openminds.publications.Chapter", "openminds.publications.ScholarlyArticle"]
        IS_SCALAR = false
    end
end
