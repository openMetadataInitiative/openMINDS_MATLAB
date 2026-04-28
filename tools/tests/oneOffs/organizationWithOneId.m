function org = organizationWithOneId()
% organizationWithOneId - test creation of a organization with one digital ID
%
%   o = organizationWithOneId()
%
%   Creates an example Organization object. If the procedure fails, an error is
%   generated.
%

    if ommtest.oneoffs.currentSchemaMajorVersion() >= 5
        org = ommtest.oneoffs.v5.organizationWithOneId();
    else
        org = ommtest.oneoffs.v4.organizationWithOneId();
    end
end
