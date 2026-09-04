function tf = isInstanceIRI(name)
% isInstanceIRI Check if a name represents an openMINDS instance IRI
%
%   tf = openminds.utility.isInstanceIRI(name) returns true if the
%   input `name` is a valid openMINDS instance IRI, and false otherwise. This
%   function verifies if `name` meets the conditions to be identified as an
%   instance IRI by:
%
%       1. Parsing the IRI scheme and host, then checking if they match
%          the expected base IRI for openMINDS instances.
%       2. Verifying that the path within the IRI starts with "instances",
%          indicating a instance.
%
%   Input:
%       name - A string containing the IRI to be validated as an instance.
%
%   Output:
%       tf - A logical value (true or false) indicating whether `name` is a
%            valid openMINDS instance IRI.
%
%   Example:
%       instanceIRI = "https://openminds.om-i.org/instances/ageCategory/adolescent"
%       tf = openminds.utility.isInstanceIRI(instanceIRI);
%
%   See also: matlab.net.URI, openminds.constant.BaseIRI

    tf = false;
    if ~startsWith(name, "http")
        return
    end

    URI = matlab.net.URI(name);
    
    isValidUrl = sprintf("%s://%s", URI.Scheme, URI.Host) == openminds.constant.BaseIRI("latest") ...
        || sprintf("%s://%s", URI.Scheme, URI.Host) == openminds.constant.BaseIRI(3);
    
    % The path is empty for an IRI with a host and nothing else, and its
    % first segment is "" for one ending in a slash. Neither names an
    % instance, and neither may index the first segment.
    URIPath = string(URI.Path);
    URIPath(URIPath == "") = [];

    isInstanceUrl = ~isempty(URIPath) && URIPath(1) == "instances";

    tf = isValidUrl && isInstanceUrl;
end
