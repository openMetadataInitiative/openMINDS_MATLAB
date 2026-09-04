function identifier = getStructIdentifier(S)
%getStructIdentifier Identifier carried by a decoded JSON-LD node, if any
%
%   identifier = getStructIdentifier(S) returns the @id of a decoded node
%   as a string. The field is at_id when the node was decoded by this
%   library and x_id when it came from MATLAB's jsondecode; both are
%   accepted. Returns "" when the node carries no identifier.

    arguments
        S (1,1) struct
    end

    if isfield(S, 'at_id')
        identifier = string(S.at_id);
    elseif isfield(S, 'x_id')
        identifier = string(S.x_id);
    else
        identifier = "";
    end

    % A null in the document decodes to [], which string() keeps empty.
    if isempty(identifier)
        identifier = "";
    end
end
