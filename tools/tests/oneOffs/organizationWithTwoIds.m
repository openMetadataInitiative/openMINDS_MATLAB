function org = organizationWithTwoIds()
% organizationWithTwoIds - test creation of a organization with two digital IDs
%
%   o = organizationWithTwoIds()
%
%   Creates an example Organization object. If the procedure fails, an error is
%   generated.
%

    if ommtest.oneoffs.currentSchemaMajorVersion() >= 5
        org = ommtest.oneoffs.v5.organizationWithTwoIds();
    else
        org = ommtest.oneoffs.v4.organizationWithTwoIds();
    end
end
