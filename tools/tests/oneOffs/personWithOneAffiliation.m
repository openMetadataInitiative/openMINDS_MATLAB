function varargout = personWithOneAffiliation()
% personWithOneAffiliation - test creation of a person object in openMINDS
%
% p = personWithOneAffiliation()
%
% Creates an example Person object. If the procedure fails, an error is
% generated.
%

if ommtest.oneoffs.currentSchemaMajorVersion() >= 5
    [varargout{1:nargout}] = ommtest.oneoffs.v5.personWithOneAffiliation();
else
    [varargout{1:nargout}] = ommtest.oneoffs.v4.personWithOneAffiliation();
end
