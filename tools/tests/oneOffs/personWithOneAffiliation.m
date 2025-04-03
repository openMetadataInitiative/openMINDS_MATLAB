function p = personWithOneAffiliation()
% personWithOneAffiliation - test creation of a person object in openMINDS
%
% p = personWithOneAffiliation()
%
% Creates an example Person object. If the procedure fails, an error is
% generated.
%

ror = openminds.core.RORID('identifier','https://ror.org/02jx3x895');
org = openminds.core.Organization('digitalIdentifier',ror,...
    'fullName','University College London');

af = openminds.core.Affiliation('memberOf', org);

orcid = openminds.core.ORCID('identifier',...
    'https://orcid.org/0000-0000-0000-0000');

contact = openminds.core.ContactInformation('email',...
    'johndsmith@somewhere.org');

p = openminds.core.Person('familyName','Smith','givenName','John D.',...
    'alternateName', "js", 'affiliation',af,'digitalIdentifier',orcid,...
    'contactInformation',contact);
