function tf = isSemanticInstanceName(name)
% isSemanticInstanceName Check if a name represents a semantic instance URI
%
%   tf = openminds.utility.isSemanticInstanceName(name) returns true if the 
%   input `name` is a valid semantic instance URI, and false otherwise. This 
%   function verifies if `name` meets the conditions to be identified as a 
%   semantic instance by:
%
%       1. Parsing the URI scheme and host, then checking if they match
%          the expected base URI for semantic instances.
%       2. Verifying that the path within the URI starts with "instances",
%          indicating a semantic instance.
%
%   Input:
%       name - A string containing the URI to be validated as a semantic
%              instance.
%
%   Output:
%       tf - A logical value (true or false) indicating whether `name` is a
%            valid semantic instance URI.
%
%   Example:
%       instanceURI = "https://openminds.om-i.org/instances/ageCategory/adolescent"
%       tf = openminds.utility.isSemanticInstanceName(instanceURI);
%
%   See also: matlab.net.URI, openminds.constant.BaseURI


    URI = matlab.net.URI(name);
    
    isValidUrl = sprintf("%s://%s", URI.Scheme, URI.Host) == ...
        openminds.constant.BaseURI;
    
    URIPath = URI.Path;
    URIPath(URIPath=="")=[];

    isInstanceUrl = URIPath(1) == "instances";

    tf = isValidUrl && isInstanceUrl;
end
