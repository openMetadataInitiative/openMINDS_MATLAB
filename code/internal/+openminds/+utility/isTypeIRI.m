function tf = isTypeIRI(name)
%isTypeIRI Check if name is a semantic name of a schema (type IRI)
    
    tf = false;

    if startsWith(name, openminds.constant.BaseURI('v1')) % v1-v3
        [~, modules] = enumeration('openminds.enum.Modules');
        typeBaseIRI = openminds.constant.BaseURI('v1') + "/" + modules;
        tf = any(startsWith(name, typeBaseIRI));
    
    elseif startsWith(name, openminds.constant.BaseURI('v4')) %v4+
        typeBaseIRI = openminds.constant.BaseURI + "/types";
        tf = startsWith(name, typeBaseIRI);
    end
end
