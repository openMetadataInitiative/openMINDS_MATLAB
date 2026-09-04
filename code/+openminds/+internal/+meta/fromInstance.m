function metaType = fromInstance(instance)
    registry = openminds.internal.meta.MetaTypeRegistry.getSingleton();
    typeClassName = class(instance);
    metaType = registry(typeClassName);
end
