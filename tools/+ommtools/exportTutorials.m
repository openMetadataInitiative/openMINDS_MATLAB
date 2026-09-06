function exportTutorials()
% exportTutorials - Run every live script and export it to docs/tutorials
%
%   Each live script is run before it is exported, so the outputs in the
%   exported files are the outputs of the current code rather than whatever
%   was last saved inside the live script. Blank-node ids in the output are
%   then normalised, so exporting twice from the same code gives the same
%   file and a commit only records a real change.

    exportFormat = [".md", ".html"];

    openmindsCodePath = openminds.toolboxdir();
    openmindsDocsPath = strrep(openmindsCodePath, 'code', 'docs');

    L = dir(fullfile(openmindsCodePath, 'livescripts', '*.mlx'));
    L = cat(1, L, dir(fullfile(openmindsCodePath, 'gettingStarted.mlx')));

    for i = 1:numel(L)
        sourcePath = fullfile(L(i).folder, L(i).name);
        targetPath = fullfile(openmindsDocsPath, 'tutorials', L(i).name);

        for j = 1:numel(exportFormat)
            exportedPath = strrep(targetPath, '.mlx', exportFormat(j));
            export(sourcePath, exportedPath, Run=true);
            if exportFormat(j) == ".html"
                postProcessLivescriptHtml(exportedPath)
            end
            normalizeIdsInFile(exportedPath)
        end
    end
end

function normalizeIdsInFile(filePath)
    text = string(fileread(filePath));
    normalized = ommtools.normalizeBlankNodeIds(text);
    if ~strcmp(normalized, text)
        fileId = fopen(filePath, "w");
        cleanup = onCleanup(@() fclose(fileId));
        fwrite(fileId, normalized, "char");
    end
end
