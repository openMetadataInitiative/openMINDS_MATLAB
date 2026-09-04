function metaType = fromInstance(instance)
% fromInstance - Describe the type of a metadata instance.
%
%   Syntax:
%       metaType = openminds.meta.fromInstance(instance) returns an
%       openminds.meta.Type describing the type of instance.
%
%   Input Arguments:
%       instance - Any openMINDS metadata instance.
%
%   Output Arguments:
%       metaType - An openminds.meta.Type object.
%
%   Description:
%       Objects are cached per type, so repeated calls for instances of the
%       same type return the same object. Prefer this over constructing an
%       openminds.meta.Type directly when describing many instances.
%
%   Example:
%       subject = openminds.core.Subject();
%       metaType = openminds.meta.fromInstance(subject);
%       metaType.PropertyNames
%
%   See also openminds.meta.Type, openminds.meta.fromClassName

    registry = openminds.internal.meta.MetaTypeRegistry.getSingleton();
    typeClassName = class(instance);
    metaType = registry(typeClassName);
end
