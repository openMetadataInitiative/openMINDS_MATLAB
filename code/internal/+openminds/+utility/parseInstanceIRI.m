function varargout = parseInstanceIRI(semanticName)
% parseInstanceIRI - Parse an openMINDS @id for a controlled instance
%
%   Syntax:
%       S = parseInstanceIRI(semanticName)
%
%       [type, name] = parseInstanceIRI(semanticName)
%
%   Input:
%       semanticName : A URI representing an openMINDS instance @id. Ex: https://openminds.ebrains.eu/instances/geneticStrainType/knockout
%
%   Output:
%       S : A struct with fields
%           - Type
%           - Name
%
%       OR
%
%       type : openMINDS type, i.e schema specification
%       name : name of instance
%
%   Example:
%
%    atId = "https://openminds.ebrains.eu/instances/geneticStrainType/knockout"
%    S = openminds.internal.utility.parseInstanceIRI(atId)
%
%    S =
%
%      struct with fields:
%
%        Type: "geneticStrainType"
%        Name: "knockout"

    URI = matlab.net.URI(semanticName);
    
    URIPath = URI.Path;
    URIPath(URIPath=="")=[];

    assert( URIPath(1) == "instances", ...
        'Provided value "%s" is not a valid @id', semanticName)
    
    type = URIPath(2);
    try
    name = URIPath(3);
    catch
        keyboard
    end
    if nargout <= 1
        varargout = {struct('Type', type, 'Name', name)};
    else
        varargout = {type, name};
    end
end
