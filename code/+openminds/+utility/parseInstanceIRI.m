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
    
    % Path is an empty double, not a string, for an IRI with a host and
    % nothing else, so it is converted before being compared or indexed,
    % as isInstanceIRI does. The error carries an identifier because a
    % caller holding an arbitrary IRI has to be able to tell this apart
    % from a genuine failure.
    URIPath = string(URI.Path);
    URIPath(URIPath=="")=[];

    if isempty(URIPath) || URIPath(1) ~= "instances"
        error('openMINDS:ParseInstanceIRI:NotAnInstanceIRI', ...
            'Provided value "%s" is not an openMINDS instance IRI.', instanceIRI)
    end

    
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
