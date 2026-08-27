function instance = controlledInstance(className, instanceName)
%controlledInstance Create a controlled instance by name, whichever API it uses
%
%   instance = ommtest.helper.controlledInstance(className, instanceName)
%   returns the named controlled instance of the given openMINDS type.
%
%   openMINDS exposes two disjoint mechanisms for controlled instances and
%   there is no common entry point. Subclasses of
%   openminds.abstract.ControlledTerm take the instance name directly in
%   their constructor, while types using the
%   openminds.internal.mixin.HasControlledInstance mixin require the static
%   fromName method and reject a string constructor argument. This function
%   dispatches on the superclass so callers do not have to know which
%   mechanism a given type uses.
%
%   Input Arguments:
%     className    - Full MATLAB class name of the controlled type.
%     instanceName - Name of the controlled instance, e.g. "Homo sapiens".
%
%   Output Arguments:
%     instance - The requested controlled instance.

    arguments
        className (1,1) string
        instanceName (1,1) string
    end

    usesMixin = any(ismember(superclasses(className), ...
        {'openminds.internal.mixin.HasControlledInstance'}));

    if usesMixin
        instance = feval(sprintf("%s.fromName", className), instanceName);
    else
        instance = feval(className, instanceName);
    end
end
