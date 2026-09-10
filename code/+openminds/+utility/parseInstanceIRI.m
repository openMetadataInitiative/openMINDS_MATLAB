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
    type = resolveTypeSegment(splitIRI(end-1), instanceIRI);

    if nargout <= 1
        varargout = {struct('Type', type, 'Name', name)};
    else
        varargout = {type, name};
    end
end

function type = resolveTypeSegment(typeSegment, instanceIRI)
% resolveTypeSegment - Resolve the type named by the segment of an instance IRI
%
%   Nearly every instance IRI names its type in the singular, which the
%   Types enumeration matches directly, ignoring case. A few name it in the
%   plural instead, as .../instances/licenses/MIT does, and openMINDS
%   publishes no plural to singular mapping. Those are resolved through the
%   instance library, which reads the type each instance document declares.
%   An IRI carrying a plural segment always refers to a library instance,
%   so the lookup covers every case the direct match does not.

    % Membership is tested by construction rather than looked up, because
    % the enumeration matches names ignoring case and offers no cheaper way
    % to ask whether a name matches.
    try
        type = openminds.enum.Types(typeSegment);
        return
    catch
        % Not a type name. Fall through to the instance library.
    end

    try
        instanceLibrary = openminds.internal.InstanceLibrary.getSingleton();
        type = instanceLibrary.getTypeFromIRISegment(typeSegment);
    catch cause
        ME = MException('openMINDS:ParseInstanceIRI:UnresolvedType', ...
            ['Could not resolve an openMINDS type from the IRI "%s". The ', ...
            'segment "%s" does not name a type in version "%s" of the ', ...
            'openMINDS model, and does not name one in the instance library ', ...
            'either.'], instanceIRI, typeSegment, openminds.version());
        ME = addCause(ME, cause);
        throw(ME)
    end
end
