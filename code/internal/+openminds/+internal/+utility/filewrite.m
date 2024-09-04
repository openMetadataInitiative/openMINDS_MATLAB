function filewrite(filePath, textStr)             
   
    folderPath = char(fileparts(filePath));
    
    if ~isempty(folderPath) && ~isfolder(folderPath)
        mkdir(folderPath)
    end
    
    fid = fopen(filePath, 'w');
    fwrite(fid, textStr);
    fclose(fid);
end
