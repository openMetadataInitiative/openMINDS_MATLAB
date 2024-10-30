function org = organizationWithTwoIds()
% organizationWithTwoIds - test creation of a organization with two digital IDs
%
%   o = organizationWithTwoIds()
%
%   Creates an example Organization object. If the procedure fails, an error is
%   generated.
%

    ror = openminds.core.RORID('identifier','https://ror.org/01xtthb56');
    
    grid = openminds.core.GRIDID('identifier', 'https://grid.ac/institutes/grid.5510.1');
    
    org = openminds.core.Organization('digitalIdentifier', {ror, grid},...
        'fullName','University of Oslo');
end
