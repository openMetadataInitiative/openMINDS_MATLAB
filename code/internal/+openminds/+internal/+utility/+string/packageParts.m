function varargout = packageParts(fullName)
%packageParts Split package name into parts
%
%   listOfParts = packageParts(packageName)
%
%   [packagePrefix, functionName] = packageParts(packageName)

    parts = strsplit(fullName, '.');

    varargout = cell(1, nargout);

    if nargout == 2
        varargout{1} = strjoin(parts(1:end-1), '.');
        varargout{2} = parts{end};
    elseif nargout == 1 || nargout == 0
        varargout = {parts};
    else
        error('Invalid number of outputs')
    end
end