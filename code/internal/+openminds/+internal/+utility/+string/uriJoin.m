function strURI = uriJoin(varargin)
%uriJoin Join segments of a URI using the forward slash (/)
    try
    if isa(varargin{1}, 'string')
        listOfStrings = [varargin{:}];
        strURI = join(listOfStrings, "/");
    elseif isa(varargin{1}, 'char')
        listOfStrings = varargin;
        strURI = strjoin(listOfStrings, '/');
    end
    catch
        varargin{:}
        error('Debug')
    end
end
