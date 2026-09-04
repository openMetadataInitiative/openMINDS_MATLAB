function metaType = fromClassName(className)
% fromClassName - Describe a metadata type by name.
%
%   Syntax:
%       metaType = openminds.meta.fromClassName(className) returns an
%       openminds.meta.Type describing the named type.
%
%   Input Arguments:
%       className - A fully qualified MATLAB class name such as
%                   "openminds.core.Subject", or a short type name such as
%                   "Subject".
%
%   Output Arguments:
%       metaType - An openminds.meta.Type object.
%
%   Description:
%       Objects are cached per type, so repeated calls for the same type
%       return the same object. Prefer this over constructing an
%       openminds.meta.Type directly when describing many types.
%
%   Example:
%       metaType = openminds.meta.fromClassName("Subject");
%       metaType.isPropertyWithLinkedType("studiedState")
%
%   See also openminds.meta.Type, openminds.meta.fromInstance

    registry = openminds.internal.meta.MetaTypeRegistry.getSingleton();
    metaType = registry(className);
end
