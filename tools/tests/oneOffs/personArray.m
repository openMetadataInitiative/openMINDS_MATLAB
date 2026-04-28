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
        
        personArguments = { ...
                     "givenName", person.givenName, ...
                    "familyName", person.familyName, ...
                 "alternateName", person.alternateName, ...
            "contactInformation", contacts(person.email) };

        if ommtest.oneoffs.currentSchemaMajorVersion() >= 5
            personArguments = [personArguments, { ...
                "preferredName", join([person.givenName, person.familyName], " ")}];
        end

        persons(end+1) = openminds.core.Person(personArguments{:});     %#ok<AGROW>
    end
end
