function validVersions = listValidVersions()
% getValidVersions - List valid openminds model version
    schemaFolder = fullfile(openminds.internal.rootpath, 'schemas/');
    L = dir(schemaFolder);
    L(startsWith({L.name}, '.')|~[L.isdir])=[];
    validVersions = {L.name};

    % if any(strcmp(validVersions, 'latest'))
    %     isLatest = strcmp(validVersions, 'latest');
    %     validVersions(isLatest) = [];
    %     validVersions = [validVersions, openminds.constant.LATEST_VERSION];
    % end
    validVersions = cellstr(validVersions);
end
