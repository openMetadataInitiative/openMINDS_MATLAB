function varargout = personWithTwoAffiliations()
% personWithTwoAffiliations - test creation of a person object in openMINDS
%
% p = personWithTwoAffiliations()
%
% Creates an example Person object. If the procedure fails, an error is
% generated.
%

if ommtest.oneoffs.currentSchemaMajorVersion() >= 5
    [varargout{1:nargout}] = ommtest.oneoffs.v5.personWithTwoAffiliations();
else
    [varargout{1:nargout}] = ommtest.oneoffs.v4.personWithTwoAffiliations();
end
