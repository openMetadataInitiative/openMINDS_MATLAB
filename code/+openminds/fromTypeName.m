function instance = fromTypeName( typeNameIRI, instanceIdentifier )
% fromTypeName - Creates an instance based on the given type name IRI.
%
% Syntax:
%   instance = openminds.fromTypeName(typeNameIRI, identifier)
%   Creates an instance of the class corresponding to the specified type
%   name IRI using the provided identifier.
%
% Input Arguments:
%   typeNameIRI (string) - The IRI representing the type name (must
%       be a valid OpenMINDS IRI).
%   instanceIdentifier (string) - Optional. An identifier (@id) of the instance
%       to create.
%
% Output Arguments:
%   instance - A blank metadata instance of the class corresponding to the
%   given type name.
%
% Example:
%  IRI = 'https://openminds.om-i.org/types/Person';
%  openminds.fromTypeName(IRI)
%
%  ans =
%
%    Person (https://openminds.om-i.org/types/Person) with properties:
%
%             affiliation: [None]  (Affiliation)
%           alternateName: [1×0 string]
%       associatedAccount: [None]  (AccountInformation)
%      contactInformation: [None]  (ContactInformation)
%       digitalIdentifier: [None]  (ORCID)
%              familyName: ""
%               givenName: ""
%
%    Required Properties: givenName

    arguments
        typeNameIRI (1,1) string {openminds.mustBeValidOpenMINDSIRI}
        instanceIdentifier (1,1) string = ''
    end
    enumType = openminds.enum.Types.fromAtType(typeNameIRI);
    instance = feval(enumType.ClassName, 'id', char(instanceIdentifier));
end
