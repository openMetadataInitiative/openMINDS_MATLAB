function downloadControlledInstances()
    % Todo: Check commit hashes to see if update is needed.
    openminds.internal.utility.git.downloadRepository('openMINDS_instances')
end
