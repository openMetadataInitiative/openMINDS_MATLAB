function p = personWithTwoAffiliations()
% personWithTwoAffiliations - test creation of a person object in openMINDS
% 
% p = personWithTwoAffiliations()
%
% Creates an example Person object. If the procedure fails, an error is
% generated.
%

ror = openminds.core.RORID('identifier','https://ror.org/02jx3x895');
orgA = openminds.core.Organization('digitalIdentifier',ror,...
    'fullName','University College London');

ror = openminds.core.RORID('identifier','https://ror.org/01xtthb56');

orgB = openminds.core.Organization('digitalIdentifier',ror,...
    'fullName', 'University of Oslo', 'shortName', 'UiO');

af = openminds.core.Affiliation('memberOf', orgA);
af(2) = openminds.core.Affiliation('memberOf', orgB);

orcid = openminds.core.ORCID('identifier',...
    'https://orcid.org/0000-0000-0000-0000');

contact = openminds.core.ContactInformation('email',...
    'johndsmith@somewhere.org');

p = openminds.core.Person('familyName','Smith','givenName','John D.',...
    'affiliation',af,'digitalIdentifier',orcid,...
    'contactInformation',contact);



