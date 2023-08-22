function filewrite(filePath, textStr)             
   
    folderPath = fileparts(filePath);
    
    if ~exist(folderPath, 'dir')
        mkdir(folderPath)
    end
    
    fid = fopen(filePath, 'w');
    fwrite(fid, textStr);
    fclose(fid);
end