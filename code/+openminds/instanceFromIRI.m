function instance = instanceFromIRI(IRI)
% instanceFromIRI - Create an instance from an openMINDS IRI
    arguments
        IRI (1,1) string {openminds.mustBeValidOpenMINDSIRI}
    end

    [type, ~] = openminds.utility.parseAtID(IRI);
    typeEnum = openminds.enum.Types(type);
    instance = feval(typeEnum.ClassName, IRI);
end
