function tag = fixtureNamespaceTag()
%fixtureNamespaceTag Short tag naming the active openMINDS namespace
%
%   tag = ommtest.helper.fixtureNamespaceTag() returns "omi" when the
%   active model uses the https://openminds.om-i.org namespace and
%   "ebrains" when it uses https://openminds.ebrains.eu.
%
%   Fixtures are named by namespace rather than by version number because
%   the namespace is what actually appears in the serialized document.

    baseIRI = openminds.constant.BaseURI();

    if startsWith(baseIRI, "https://openminds.om-i.org")
        tag = "omi";
    elseif startsWith(baseIRI, "https://openminds.ebrains.eu")
        tag = "ebrains";
    else
        error('ommtest:fixtureNamespaceTag:UnknownNamespace', ...
            'No fixture tag defined for base IRI "%s".', baseIRI)
    end
end
