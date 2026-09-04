function metaType = fromClassName(className)
    registry = openminds.internal.meta.MetaTypeRegistry.getSingleton();
    metaType = registry(className);
end
