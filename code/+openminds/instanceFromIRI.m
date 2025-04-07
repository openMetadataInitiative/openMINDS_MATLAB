function instance = instanceFromIRI(iri)
    [type, ~] = openminds.utility.parseAtID(iri);
    typeEnum = openminds.enum.Types(type);
    instance = feval(typeEnum.ClassName, iri);
end
