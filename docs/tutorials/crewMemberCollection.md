
# <span style="color:rgb(213,80,0)">Metadata instances and collections</span>

In this example we will create a metadata collection for the crew members of the "Heart of Gold" Spacecraft as described in the openMINDS [getting started](https://openminds-documentation.readthedocs.io/en/latest/shared/getting_started.html) guide.


We start by importing a csv file with crew member information:

```matlab
filePath = fullfile(openminds.toolboxdir(), "livescripts", "data", "spacecraft_crew_members.csv");
crewMembers = readtable(filePath, "TextType", "String")
```
| |givenName|familyName|alternateName|email|memberOf|
|:--:|:--:|:--:|:--:|:--:|:--:|
|1|"Arthur"|"Dent"|<missing>|"arthur-dent@hitchhikers-guide.galaxy"|"Heart of Gold Spacecraft Crew"|
|2|"Ford"|"Prefect"|<missing>|"ford-prefect@hitchhikers-guide.galaxy"|"Heart of Gold Spacecraft Crew"|
|3|"Tricia Marie"|"McMillan"|"Trillian Astra"|"trillian-astra@hitchhikers-guide.galaxy"|"Heart of Gold Spacecraft Crew"|
|4|"Zaphod"|"Beeblebrox"|<missing>|"zaphod-beeblebrox@hitchhikers-guide.galaxy"|"Heart of Gold Spacecraft Crew"|

# Create instances

Let us create a set of metadata instances from this table that represents the crew members. We assume that <samp>memberOf</samp> provides the full name of a consortium each person is affiliated to. Since members might be affiliated to the same consortium we assume further that the same full name means the same consortium. We can also assume that the <samp>email</samp> is unique for each person.


With these assumptions we will create:

-  a metadata <samp>Collection</samp> for storing metadata instances 
-  a unique set of <samp>Consortium</samp> instances based on the name given in the <samp>memberOf</samp> column 
-  a <samp>ContactInformation</samp> instance based on the <samp>email</samp> column 
-  a <samp>Person</samp> instance for each table row with: 
-      the <samp>givenName</samp>, <samp>familyName</samp>, and <samp>alternateName</samp> (if available) 
-      a link to the respective  <samp>ContactInformation</samp> instance 
-      a person-specific embedded <samp>Affiliation</samp> instance that links to the respective <samp>Consortium</samp> instance 

We start by creating an empty metadata collection for storing metadata instances.

```matlab
% Create an empty metadata collection
collection = openminds.Collection(...
           "Name", "Crew Members", ...
    "Description", "Crew members of the 'Heart of Gold' spacecraft")
```

```TextOutput
collection = 
  Collection with properties:
           Name: "Crew Members"
    Description: "Crew members of the 'Heart of Gold' spacecraft"
          Nodes: dictionary with unset key and value types
```

The collection will hold instances in a dictionary object of the Nodes property. Note: the <samp>Name</samp> and <samp>Description</samp> are optional and are currently not stored with the metadata instances.


We move on and start creating instances for the consortia:

```matlab
% Define a utility function for creating instance ids:
createId = @(str) lower(sprintf('_:%s', replace(str, ' ', '-')));

% Extract the unique "memberOf" names to create dictionary 
% with unique "Consortium" instances
uniqueConsortiumNames = unique(crewMembers.memberOf);

consortia = dictionary;
for consortiumName = uniqueConsortiumNames'    
    consortia(consortiumName) = openminds.core.Consortium(...
              'id', createId(consortiumName), ...
        'fullName', consortiumName );
end

disp(consortia)
```

```TextOutput
  dictionary (string ⟼ openminds.core.actors.Consortium) with 1 entry:
    "Heart of Gold Spacecraft Crew" ⟼ [Heart of Gold Spacecraft Crew]  (Consortium)
```

We have now created a dictionary that holds the <samp>Consortium</samp> instances. Since all the persons in this example belongs to the same consortium, this dictionary only holds one instance.


We can also look at the <samp>Consortium</samp> instance in more detail:

```matlab
disp(consortia("Heart of Gold Spacecraft Crew"))
```

```TextOutput
  Consortium (https://openminds.ebrains.eu/core/Consortium) with properties:
    contactInformation: [None]  (ContactInformation)
              fullName: "Heart of Gold Spacecraft Crew"
              homepage: ""
             shortName: ""
  Required Properties: fullName
```

The <samp>Consortium</samp> instance has four properties, and we have filled out <samp>fullName</samp>. Whenever you create an openMINDS instance in MATLAB, you can either supply one or more name-value pairs when you create the instance (as we did above), or you can first create the instance and then assign values using dot-indexing on the instance object.

```matlab
consortium = openminds.core.Consortium();
consortium.fullName = "Heart of Gold Spacecraft Crew"
```

```TextOutput
consortium = 
  Consortium (https://openminds.ebrains.eu/core/Consortium) with properties:
    contactInformation: [None]  (ContactInformation)
              fullName: "Heart of Gold Spacecraft Crew"
              homepage: ""
             shortName: ""
  Required Properties: fullName
```

When the instance is displayed, you will see all the properties that are part of the instance type, and which of those are required (Note: at the moment of writing this guide, required properties are not enforced). The display should also give information about what types are expected for each of the property values. For example, the <samp>contactInformation</samp> property requires a <samp>ContactInformation</samp> instance (as indicated by the annotation in the brackets). If you want to learn more about the types as you explore the instances, you can always press the links in the instance display and they will take you to the openMINDS documentation page for that instance.


The consortium in this example does not have contact information, but we will move on and create <samp>ContactInformation</samp> types for each of the persons:

```matlab
% Create a dictionary to hold "ContactInformation" instances
contacts = dictionary;

for email = crewMembers.email'
    contacts(email) = openminds.core.ContactInformation(...
           'id', createId(email), ...
        'email', email );
end
disp(contacts)
```

```TextOutput
  dictionary (string ⟼ openminds.core.actors.ContactInformation) with 4 entries:
    "arthur-dent@hitchhikers-guide.galaxy"       ⟼ [arthur-dent@hitchhikers-guide.galaxy]  (ContactInformation)
    "ford-prefect@hitchhikers-guide.galaxy"      ⟼ [ford-prefect@hitchhikers-guide.galaxy]  (ContactInformation)
    "trillian-astra@hitchhikers-guide.galaxy"    ⟼ [trillian-astra@hitchhikers-guide.galaxy]  (ContactInformation)
    "zaphod-beeblebrox@hitchhikers-guide.galaxy" ⟼ [zaphod-beeblebrox@hitchhikers-guide.galaxy]  (ContactInformation)
```

This gave us four <samp>ContactInformation</samp> instances. Finally we will create <samp>Person</samp> instances and attach the <samp>ContactInformation</samp> and <samp>Consortium</samp> instances:

```matlab
% Extract data to create a list of "Person" instances where each "Person" 
% instance will link to their respective "ContactInformation" instance and
% embed an "Affiliation" instance that links to the respective "Consortium" instance
persons = openminds.core.Person.empty;

for iRow = 1:height(crewMembers)

    person = crewMembers(iRow,:);
    fullName = person.givenName + " " + person.familyName;
    
    persons(end+1) = openminds.core.Person( ...
                        'id', createId(fullName), ...
                 'givenName', person.givenName, ...
                'familyName', person.familyName, ...
             'alternateName', person.alternateName, ...
        'contactInformation', contacts(person.email), ...
               'affiliation', openminds.core.Affiliation('memberOf', consortia(person.memberOf) )); %#ok<SAGROW>
end
```
# Add instances to collection and export collection

Now that we have all the instances, we can add them to the <samp>collection</samp>. It is sufficient to add the <samp>Person</samp> instances because the collection will automatically detect linked and embedded instances and add them automatically to the <samp>Nodes</samp> property.

```matlab
collection.add(persons)
disp(collection)
```

```TextOutput
  Collection with properties:
           Name: "Crew Members"
    Description: "Crew members of the 'Heart of Gold' spacecraft"
          Nodes: dictionary (string ⟼ cell) with 9 entries
```

As described above, we see that the <samp>Nodes</samp> hold 9 instances. We can look at the <samp>Nodes</samp> and we should expect to see 4 <samp>Person</samp> instances, 4 <samp>ContactInformation</samp> instances and 1 <samp>Consortium</samp> instance.

```matlab
disp(collection.Nodes)
```

```TextOutput
  dictionary (string ⟼ cell) with 9 entries:
    "_:arthur-dent"                                ⟼ {[Dent, Arthur]  (Person)}
    "_:arthur-dent@hitchhikers-guide.galaxy"       ⟼ {[arthur-dent@hitchhikers-guide.galaxy]  (ContactInformation)}
    "_:heart-of-gold-spacecraft-crew"              ⟼ {[Heart of Gold Spacecraft Crew]  (Consortium)}
    "_:ford-prefect"                               ⟼ {[Prefect, Ford]  (Person)}
    "_:ford-prefect@hitchhikers-guide.galaxy"      ⟼ {[ford-prefect@hitchhikers-guide.galaxy]  (ContactInformation)}
    "_:tricia-marie-mcmillan"                      ⟼ {[McMillan, Tricia Marie]  (Person)}
    "_:trillian-astra@hitchhikers-guide.galaxy"    ⟼ {[trillian-astra@hitchhikers-guide.galaxy]  (ContactInformation)}
    "_:zaphod-beeblebrox"                          ⟼ {[Beeblebrox, Zaphod]  (Person)}
    "_:zaphod-beeblebrox@hitchhikers-guide.galaxy" ⟼ {[zaphod-beeblebrox@hitchhikers-guide.galaxy]  (ContactInformation)}
```

A note here: Since the collection holds a mix of different types, each type is inside a cell (as indicated by the curly brackets). In order to get an instance from the <samp>Nodes</samp>, we need to use curly bracket indexing:

```matlab
person = collection.Nodes{"_:arthur-dent"}
```

```TextOutput
person = 
  Person (https://openminds.ebrains.eu/core/Person) with properties:
           affiliation: Heart of Gold Spacecraft Crew  (Affiliation)
         alternateName: <missing>
     associatedAccount: [None]  (AccountInformation)
    contactInformation: arthur-dent@hitchhikers-guide.galaxy  (ContactInformation)
     digitalIdentifier: [None]  (ORCID)
            familyName: "Dent"
             givenName: "Arthur"
  Required Properties: givenName
```

Finally, we can save the collection

```matlab
% Save the instances to the openMINDS userdata folder:
savePath = fullfile(userpath, "openMINDS_MATLAB", "demo", "crew_members.jsonld");
collection.save(savePath)

% Check out the saved metadata:
str = fileread(savePath);
disp(str)
```

```TextOutput
{
  "@context": {
    "@vocab": "https://openminds.ebrains.eu/vocab/"
  },
  "@graph": [
    {
      "@id": "_:arthur-dent",
      "@type": "https://openminds.ebrains.eu/core/Person",
      "affiliation": [
        {
          "@type": "https://openminds.ebrains.eu/core/Affiliation",
          "memberOf": {
            "@id": "_:heart-of-gold-spacecraft-crew"
          }
        }
      ],
      "contactInformation": {
        "@id": "_:arthur-dent@hitchhikers-guide.galaxy"
      },
      "familyName": "Dent",
      "givenName": "Arthur"
    },
    {
      "@id": "_:arthur-dent@hitchhikers-guide.galaxy",
      "@type": "https://openminds.ebrains.eu/core/ContactInformation",
      "email": "arthur-dent@hitchhikers-guide.galaxy"
    },
    {
      "@id": "_:heart-of-gold-spacecraft-crew",
      "@type": "https://openminds.ebrains.eu/core/Consortium",
      "fullName": "Heart of Gold Spacecraft Crew"
    },
    {
      "@id": "_:ford-prefect",
      "@type": "https://openminds.ebrains.eu/core/Person",
      "affiliation": [
        {
          "@type": "https://openminds.ebrains.eu/core/Affiliation",
          "memberOf": {
            "@id": "_:heart-of-gold-spacecraft-crew"
          }
        }
      ],
      "contactInformation": {
        "@id": "_:ford-prefect@hitchhikers-guide.galaxy"
      },
      "familyName": "Prefect",
      "givenName": "Ford"
    },
    {
      "@id": "_:ford-prefect@hitchhikers-guide.galaxy",
      "@type": "https://openminds.ebrains.eu/core/ContactInformation",
      "email": "ford-prefect@hitchhikers-guide.galaxy"
    },
    {
      "@id": "_:tricia-marie-mcmillan",
      "@type": "https://openminds.ebrains.eu/core/Person",
      "affiliation": [
        {
          "@type": "https://openminds.ebrains.eu/core/Affiliation",
          "memberOf": {
            "@id": "_:heart-of-gold-spacecraft-crew"
          }
        }
      ],
      "alternateName": [
        "Trillian Astra"
      ],
      "contactInformation": {
        "@id": "_:trillian-astra@hitchhikers-guide.galaxy"
      },
      "familyName": "McMillan",
      "givenName": "Tricia Marie"
    },
    {
      "@id": "_:trillian-astra@hitchhikers-guide.galaxy",
      "@type": "https://openminds.ebrains.eu/core/ContactInformation",
      "email": "trillian-astra@hitchhikers-guide.galaxy"
    },
    {
      "@id": "_:zaphod-beeblebrox",
      "@type": "https://openminds.ebrains.eu/core/Person",
      "affiliation": [
        {
          "@type": "https://openminds.ebrains.eu/core/Affiliation",
          "memberOf": {
            "@id": "_:heart-of-gold-spacecraft-crew"
          }
        }
      ],
      "contactInformation": {
        "@id": "_:zaphod-beeblebrox@hitchhikers-guide.galaxy"
      },
      "familyName": "Beeblebrox",
      "givenName": "Zaphod"
    },
    {
      "@id": "_:zaphod-beeblebrox@hitchhikers-guide.galaxy",
      "@type": "https://openminds.ebrains.eu/core/ContactInformation",
      "email": "zaphod-beeblebrox@hitchhikers-guide.galaxy"
    }
  ]
}
```
