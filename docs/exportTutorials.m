function exportTutorials()
    
    exportFormat = [".md", ".html"];

    openmindsCodePath = openminds.internal.rootpath();
    openmindsDocsPath = strrep(openmindsCodePath, 'code', 'docs');

    L = dir(fullfile(openmindsCodePath, 'livescripts', '*.mlx'));
    
    for i = 1:numel(L)
        sourcePath = fullfile(L(i).folder, L(i).name);
        targetPath = fullfile(openmindsDocsPath, 'tutorials', L(i).name);
        
        for j = 1:numel(exportFormat)
            export(sourcePath, strrep(targetPath, '.mlx', exportFormat(j)));
        end
    end
end