function filewrite(filePath, textStr)
   
    folderPath = char(fileparts(filePath));
    
    if ~isempty(folderPath) && ~isfolder(folderPath)
        mkdir(folderPath)
    end
    
    % Written as UTF-8 regardless of the platform default encoding, so a
    % file is read back the same way on every platform.
    fid = fopen(filePath, 'w', 'n', 'UTF-8');
    fwrite(fid, textStr, 'char');
    fclose(fid);
end
