function tf = isMixedInstance(value)
% isMixedInstance - Check if value is a metadata instance of a mixed type class
%
%   tf = openminds.utility.isMixedInstance(value)

    % Todo: Should it work for arrays and cell arrays?
    tf = isa(value, 'openminds.abstract.internal.LinkedCategory');
end