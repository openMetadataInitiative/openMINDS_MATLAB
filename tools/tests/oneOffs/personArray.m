function persons = personArray()

    filePath = fullfile(openminds.internal.rootpath, "livescripts", "data", "spacecraft_crew_members.csv");
    crewMembers = readtable(filePath, "TextType", "String");

    contacts = dictionary;
    
    for email = crewMembers.email'
        contacts(email) = openminds.core.ContactInformation(...
            'email', email );
    end

    persons = openminds.core.Person.empty;

    for iRow = 1:height(crewMembers)
    
        person = crewMembers(iRow,:);
        
        persons(end+1) = openminds.core.Person( ...
                     'givenName', person.givenName, ...
                    'familyName', person.familyName, ...
                 'alternateName', person.alternateName, ...
            'contactInformation', contacts(person.email) );     %#ok<AGROW>
    end
end
