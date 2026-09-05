function metaType = fromInstance(instance)
% fromInstance - Describe the type of a metadata instance.
%
%   Syntax:
%       metaType = openminds.introspection.fromInstance(instance) returns an
%       openminds.introspection.MetaType describing the type of instance.
%
%   Input Arguments:
%       instance - Any openMINDS metadata instance.
%
%   Output Arguments:
%       metaType - An openminds.introspection.MetaType object.
%
%   Description:
%       Objects are cached per type, so repeated calls for instances of the
%       same type return the same object. Prefer this over constructing an
%       openminds.introspection.MetaType directly when describing many instances.
%
%   Example:
%       subject = openminds.core.Subject();
%       metaType = openminds.introspection.fromInstance(subject);
%       metaType.PropertyNames
%
%   See also openminds.introspection.MetaType, openminds.introspection.fromClassName

    registry = openminds.introspection.internal.MetaTypeRegistry.getSingleton();
    typeClassName = class(instance);
    metaType = registry(typeClassName);
end
