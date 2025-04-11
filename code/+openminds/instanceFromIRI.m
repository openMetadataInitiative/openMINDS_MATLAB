function instance = instanceFromIRI(IRI)
% instanceFromIRI - Create an instance from an openMINDS IRI
% 
% Syntax:
%   instance = openminds.instanceFromIRI(IRI) Creates an instance based on the 
%   provided openMINDS IRI.
% 
% Input Arguments:
%   IRI - A scalar string representing an openMINDS instance IRI.
% 
% Output Arguments:
%   instance - A metadata instance corresponding to the given IRI.
%
% Example:
%   
%  IRI = "https://openminds.ebrains.eu/instances/biologicalSex/male";
%  instance = openminds.instanceFromIRI(IRI)
%  
%  instance = 
%  
%    BiologicalSex (https://openminds.om-i.org/types/BiologicalSex) with properties:
%  
%                       definition: "Biological sex that produces sperm cells (spermatozoa)."
%                      description: "A male organism typically has the capacity to produce relatively small, usually mobile gametes (reproductive cells), called sperm cells (or spermatozoa). In the process of fertilization, these sperm cells fuse with a larger, usually immobile female gamete, called egg cell (or ovum)."
%               interlexIdentifier: "http://uri.interlex.org/base/ilx_0106489"
%               knowledgeSpaceLink: ""
%                             name: "male"
%      preferredOntologyIdentifier: "http://purl.obolibrary.org/obo/PATO_0000384"
%                          synonym: [1×0 string]
%  
%    Required Properties: name

    arguments
        IRI (1,1) string {openminds.mustBeValidOpenMINDSIRI}
    end

    [type, ~] = openminds.utility.parseAtID(IRI);
    typeEnum = openminds.enum.Types(type);
    instance = feval(typeEnum.ClassName, IRI);
end
