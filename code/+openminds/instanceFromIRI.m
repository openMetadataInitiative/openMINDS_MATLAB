function instance = instanceFromIRI(iri)
    
    validBaseIri = [...
        "https://openminds.ebrains.eu", ...
        "https://openminds.om-i.org",
        ];

    assert(startsWith(iri, validBaseIri), ...
        'Expected IRI to start with %s\n', ...
        strjoin("""" + validBaseIri + """", ' or '));

    [type, ~] = openminds.utility.parseAtID(iri);
    typeEnum = openminds.enum.Types(type);
    instance = feval(typeEnum.ClassName, iri);
end
