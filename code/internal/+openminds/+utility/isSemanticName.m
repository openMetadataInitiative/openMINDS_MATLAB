function tf = isSemanticName(name)

    URI = matlab.net.URI(name);
    
    isValidUrl = sprintf("%s://%s", URI.Scheme, URI.Host) == ...
        openminds.internal.constants.url.OpenMindsBaseURL;

    URIPath = URI.Path;
    URIPath(URIPath=="")=[];

    isInstanceUrl = URIPath(1) == "instances";

    tf = isValidUrl && isInstanceUrl;
end
