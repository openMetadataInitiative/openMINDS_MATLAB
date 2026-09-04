function keywordFields = jsonLdKeywordFields()
%jsonLdKeywordFields Field names that carry JSON-LD keywords in a decoded node
%
%   keywordFields = jsonLdKeywordFields() returns the struct field names a
%   decoded JSON-LD node uses for @id, @type and @context, in both the at_
%   form written by this library's decoder and the x_ form written by
%   MATLAB's jsondecode. Every other field of a decoded node is a property
%   value.

    keywordFields = ["at_id", "x_id", "at_type", "x_type", "at_context", "x_context"];
end
