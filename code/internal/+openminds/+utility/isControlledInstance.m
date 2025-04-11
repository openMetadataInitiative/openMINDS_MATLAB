function tf = isControlledInstance(value)
% isInstance - Check if a value is an openMINDS controlled metadata instance / object
%
%   tf = openminds.utility.isControlledInstance(value)

    % Todo: Should it work for arrays and cell arrays?
    tf = isa(value, 'openminds.abstract.ControlledTerm');
end
