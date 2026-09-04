function metaType = fromClassName(className)
% fromClassName - Describe a metadata type by name.
%
%   Syntax:
%       metaType = openminds.introspection.fromClassName(className) returns an
%       openminds.introspection.MetaType describing the named type.
%
%   Input Arguments:
%       className - A fully qualified MATLAB class name such as
%                   "openminds.core.Subject", or a short type name such as
%                   "Subject".
%
%   Output Arguments:
%       metaType - An openminds.introspection.MetaType object.
%
%   Description:
%       Objects are cached per type, so repeated calls for the same type
%       return the same object. Prefer this over constructing an
%       openminds.introspection.MetaType directly when describing many types.
%
%   Example:
%       metaType = openminds.introspection.fromClassName("Subject");
%       metaType.isPropertyWithLinkedType("studiedState")
%
%   See also openminds.introspection.MetaType, openminds.introspection.fromInstance

    registry = openminds.introspection.internal.MetaTypeRegistry.getSingleton();
    metaType = registry(className);
end
