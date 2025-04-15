function jsonInstance = toJsonld(instance)
    import openminds.internal.serializer.StructConverter
    import openminds.internal.serializer.JsonLdSerializer
    
    structs = StructConverter(instance, 'WithContext', false).convert();
    jsonInstance = openminds.internal.serializer.struct2jsonld(structs);
end
