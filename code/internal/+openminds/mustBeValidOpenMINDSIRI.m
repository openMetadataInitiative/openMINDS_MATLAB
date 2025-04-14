function mustBeValidOpenMINDSIRI(IRI)
    arguments
        IRI (1,1) string
    end

    % Todo: Get these from a constant
    validBaseIRI = [...
        "https://openminds.ebrains.eu", ...
        "https://openminds.om-i.org" ...
    ];

    if ~startsWith(IRI, validBaseIRI)
        % Create a readable string that lists all valid base IRIs with quotes
        validStr = strjoin(compose('"%s"', validBaseIRI), ' or ');
        
        % Throw an error that includes the provided IRI and the valid prefixes.
        error('OPENMINDS_MATLAB:Validators:InvalidOpenMINDSIRI',...
              ['The provided IRI "%s" is invalid. It must begin with one of ' ...
              'the following valid prefixes: %s.'], IRI, validStr);
    end
end
