function outputPaths = saveInstances(instance, filePath, options)
%saveInstances Save metadata instance(s) to file(s)

    % TODO:
    %   - Test that it works when passing instance with recursiveness turned on
    %   - Test that it works for list of instances in same situation, when
    %       a) saving to individual files
    %       b) saving to single file
    %   - Generalize saving to save to different formats.

    %   - Option for flat or nested.
    
    arguments
        instance (1,:) %openminds.abstract.Schema or cell array
        filePath (1,1) string = ""
        options.OutputFormat (1,1) string = "jsonld"
        options.RecursionDepth = 1
        options.SaveToSingleFile = true
    end

    import openminds.internal.serializer.StructConverter
    import openminds.internal.serializer.JsonLdSerializer
    
    if options.SaveToSingleFile
        outputMode = "single";
    else
        outputMode = "multiple";
    end

    switch options.OutputFormat

        case "jsonld"

            serializer = openminds.internal.serializer.JsonLdSerializer(...
                "RecursionDepth", options.RecursionDepth, ...
                "PropertyNameSyntax", "compact", ...
                "PrettyPrint", true, ...
                "OutputMode", outputMode);
        
            jsonldDocuments = serializer.serialize(instance);

            if options.SaveToSingleFile
                if filePath==""
                    disp(jsonldDocuments)
                else
                    openminds.internal.utility.filewrite(filePath, jsonldDocuments)
                end
                outputPaths = filePath;
            else

                if ~iscell(jsonldDocuments); str = {jsonldDocuments}; end

                outputPaths = cell(size(jsonldDocuments));

                for i = 1:numel(jsonldDocuments)
                    if filePath==""
                        disp(jsonldDocuments{i})
                    else
                        thisFilePath = buildSingleInstanceFilepath(filePath, jsonldDocuments{i});
                        openminds.internal.utility.filewrite(thisFilePath, jsonldDocuments{i})
                        outputPaths{i} = char(thisFilePath);
                    end
                end
            end
        otherwise
            error('Unkown output format')
    end
end

function instanceFilePath = buildSingleInstanceFilepath(rootPath, jsonldInstance)
%buildSingleInstanceFilepath Build filepath for single instance.
%
%   Use the @type to create a filepath consisting of a folder hierarchy
%   based on the openMINDS type the instance belong to.
%
%   Example:
%
%   @type = "https://openminds.ebrains.eu/core/Affiliation"
%
%   instanceFilePath = <RootPath>/affiliation/<@id>.jsonld

    instance = openminds.internal.utility.json.decode(jsonldInstance);
    type = openminds.enum.Types.fromAtType(instance.at_type);
        
    saveFolder = fullfile(rootPath, lower(char(type)));
    if ~isfolder(saveFolder); mkdir(saveFolder); end

    instanceFilePath = fullfile(saveFolder, [instance.at_id, '.jsonld']);
end
