function outputPaths = saveInstances(instance, filePath, options)
%saveInstances Save metadata instance(s) to file(s)

    % TODO:    
    %   - Test that it works when passing instance with recursiveness turned on
    %   - Test that it works for list of instances in same situation, when
    %       a) saving to individual files
    %       b) saving to single file
    %   - Generalize saving to save to different formats.
    
    arguments
        instance (1,:) %openminds.abstract.Schema or cell array
        filePath (1,1) string = ""
        options.OutputFormat (1,1) string = "jsonld"
        options.RecursionDepth = 1
        options.SaveToSingleFile = true
    end

    import openminds.internal.serializer.StructConverter
    import openminds.internal.serializer.JsonLdSerializer
    
    switch options.OutputFormat
        case "jsonld"
            if options.SaveToSingleFile
                outputMode = "single";
            else
                outputMode = "multiple";
            end
            
            if options.SaveToSingleFile   
                structs = StructConverter(instance, 'WithContext', false).convert();
                jsonInstance = openminds.internal.serializer.struct2jsonld(structs);
                
                if filePath==""
                    disp(jsonInstance)
                else
                    openminds.internal.utility.filewrite(filePath, jsonInstance)
                end
                outputPaths = filePath;
            else
                str = JsonLdSerializer(instance, 'RecursionDepth', options.RecursionDepth).convert(outputMode);                
                if ~iscell(str); str = {str}; end

                outputPaths = cell(size(str));

                for i = 1:numel(str)
                    if filePath==""
                        disp(str{i})
                    else
                        thisFilePath = buildSingleInstanceFilepath(filePath, str{i});
                        openminds.internal.utility.filewrite(thisFilePath, str{i})
                        outputPaths{i} = char(thisFilePath);
                    end
                end
            end
            
        otherwise
            error('Unkown output format')
    end

    if ~nargout
        clear jsonInstance
    end
end

function instanceFilePath = buildSingleInstanceFilepath(rootPath, jsonldInstance)
%buildSingleInstanceFilepath Build filepath for single instance.
%
%   Use the @type to create a filepath consisting of a folder hierarchy
%   base on the openMINDS model the instance belong to.
%
%   Example:
%
%   @type = "https://openminds.ebrains.eu/core/Affiliation"
%
%   instanceFilePath = <RootPath>/core/Affiliation/<@id>.jsonld

    instance = openminds.internal.serializer.jsonld2struct(jsonldInstance);
    classname = openminds.internal.utility.string.type2class(instance.at_type); %openminds.core.Affiliation
    folderName = strrep(classname, '.', filesep);
    folderName = strrep(folderName, 'openminds', rootPath);
    if ~isfolder(folderName); mkdir(folderName); end
    [~, filename] = fileparts(instance.at_id);
    instanceFilePath = fullfile(folderName, [filename, '.jsonld']);
end
