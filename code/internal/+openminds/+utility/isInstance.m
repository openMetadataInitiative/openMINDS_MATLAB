function tf = isInstance(value)
% isInstance - Check if a value is an openMINDS metadata instance / object
%
%   tf = openminds.utility.isInstance(value)

    % Todo: Should it work for arrays and cell arrays?
    tf = isa(value, 'openminds.abstract.Schema');
end