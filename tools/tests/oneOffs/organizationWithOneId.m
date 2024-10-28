function org = organizationWithOneId()
% organizationWithOneId - test creation of a organization with one digital ID
%
%   o = organizationWithOneId()
%
%   Creates an example Organization object. If the procedure fails, an error is
%   generated.
%

    ror = openminds.core.RORID('identifier','https://ror.org/01xtthb56');
    
    org = openminds.core.Organization('digitalIdentifier', ror,...
        'fullName','University of Oslo');
end
