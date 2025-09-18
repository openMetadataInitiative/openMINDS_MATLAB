function varargout = parseInstanceIRI(instanceIRI)
% parseInstanceIRI - Parse an openMINDS @id for a controlled instance
%
%   Syntax:
%       S = parseInstanceIRI(instanceIRI)
%
%       [type, name] = parseInstanceIRI(instanceIRI)
%
%   Input:
%       instanceIRI : A URI/IRI representing an openMINDS instance IRI. 
%       Ex: https://openminds.ebrains.eu/instances/geneticStrainType/knockout
%
%   Output:
%       S : A struct with fields
%           - Type (openminds.enum.Types)
%           - Name (string)
%     OR
%       type : openMINDS type enum
%       name : name of instance
%
%   Example:
%
%    instanceIRI = "https://openminds.ebrains.eu/instances/geneticStrainType/knockout"
%    S = openminds.utility.parseInstanceIRI(instanceIRI)
%
%    S =
%
%      struct with fields:
%
%        Type: "GeneticStrainType"
%        Name: "knockout"

    arguments
        instanceIRI (1,1) string
    end

    URI = matlab.net.URI(instanceIRI);
    
    URIPath = URI.Path;
    URIPath(URIPath=="")=[];

    assert( URIPath(1) == "instances", ...
        'Provided value "%s" is not a valid @id', instanceIRI)
    
    splitIRI = split(instanceIRI, "/");

    name = splitIRI(end);
    typeName = splitIRI(end-1);
    type = openminds.enum.Types(typeName);

    if nargout <= 1
        varargout = {struct('Type', type, 'Name', name)};
    else
        varargout = {type, name};
    end
end
