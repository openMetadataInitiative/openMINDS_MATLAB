
# Metadata instances and collections

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

Let us create a set of metadata instances from this table that represents the crew members. We assume that `memberOf` provides the full name of the consortium each person belongs to. A **`Consortium`** describes the group, while its `memberships` property lists the actors that belong to it. Since multiple people can belong to the same consortium, identical `memberOf` values are treated as references to the same **`Consortium`** instance. We also assume that `email` is unique for each person.


With these assumptions we will create:

-  a metadata `Collection` for storing metadata instances 
-  a unique set of **`Consortium`** instances based on the name given in the `memberOf` column 
-  a **`ContactInformation`** instance for each unique email address 
-  a **`Person`** instance for each table row, using `givenName`, `familyName`, `preferredName`, `alternateName` if available, and the corresponding **`ContactInformation`** 
-  a **`Membership`** instance for each person, assigned to the corresponding **`Consortium`** 

We start by creating an empty metadata collection for storing metadata instances.

```matlab
% Create an empty metadata collection
collection = openminds.Collection(...
           "Name", "Crew Members", ...
    "Description", "Crew members of the 'Heart of Gold' spacecraft")
```

```matlabTextOutput
collection = 
  Collection with properties:

             Name: "Crew Members"
      Description: "Crew members of the 'Heart of Gold' spacecraft"
            Nodes: dictionary with unset key and value types
     LinkResolver: []
    MetadataStore: [0x0 openminds.internal.FileMetadataStore]

```

The collection will hold instances in a dictionary object of the `Nodes` property. Note: the `Name` and `Description` are optional and are currently not stored with the metadata instances.


We move on and start creating instances for the consortia:

```matlab
% Define a utility function for creating instance ids:
createId = @(str) lower(sprintf('_:%s', replace(str, ' ', '-')));

% Extract the unique "memberOf" names to create dictionary 
% with unique "Consortium" instances
uniqueConsortiumNames = unique(crewMembers.memberOf);

% Create dictionary. Fall back to containers.Map for MATLAB < R2022b
try consortia = dictionary; catch; consortia = containers.Map; end
for consortiumName = uniqueConsortiumNames'    
    consortia(consortiumName) = openminds.core.Consortium(...
              'id', createId(consortiumName), ...
        'fullName', consortiumName );
end

disp(consortia)
```

```matlabTextOutput
  dictionary (string ⟼ openminds.core.actors.Consortium) with 1 entry:

    "Heart of Gold Spacecraft Crew" ⟼ [Heart of Gold Spacecraft Crew] (Consortium)
```

We have now created a dictionary that holds the `Consortium` instances. Since all the persons in this example belong to the same consortium, this dictionary only holds one instance.


We can also look at the `Consortium` instance in more detail:

```matlab
disp(consortia("Heart of Gold Spacecraft Crew"))
```

```matlabTextOutput
  Consortium (_:heart-of-gold-spacecraft-crew) with properties:

    contactInformation: [None] (ContactInformation)
              fullName: "Heart of Gold Spacecraft Crew"
              homepage: ""
           memberships: [None] (Membership)
             shortName: ""

  Required Properties: fullName, memberships
```

The `Consortium` instance has five properties, and we have filled out `fullName`. Whenever you create an openMINDS instance in MATLAB, you can either supply one or more name\-value pairs when you create the instance (as we did above), or you can first create the instance and then assign values using dot\-indexing on the instance object.

```matlab
consortium = openminds.core.Consortium();
consortium.fullName = "Heart of Gold Spacecraft Crew"
```

```matlabTextOutput
consortium = 
  Consortium (_:18b0099e-01fd-482f-81dc-6721c18ab2d8) with properties:

    contactInformation: [None] (ContactInformation)
              fullName: "Heart of Gold Spacecraft Crew"
              homepage: ""
           memberships: [None] (Membership)
             shortName: ""

  Required Properties: fullName, memberships

```

When the instance is displayed, you will see all the properties that are part of the instance type, and which of those are required (Note: at the moment of writing this guide, required properties are not enforced). The display should also give information about what types are expected for each of the property values. For example, the `contactInformation` property requires a `ContactInformation` instance (as indicated by the annotation in the brackets). If you want to learn more about the types as you explore the instances, you can always press the links in the instance display and they will take you to the openMINDS documentation page for that instance.


The consortium in this example does not have contact information, but we will move on and create `ContactInformation` types for each of the persons:

```matlab
% Create a dictionary to hold "ContactInformation" instances
try contacts = dictionary; catch; contacts = containers.Map; end

for email = crewMembers.email'
    contacts(email) = openminds.core.ContactInformation(...
           'id', createId(email), ...
        'email', email );
end
disp(contacts)
```

```matlabTextOutput
  dictionary (string ⟼ openminds.core.actors.ContactInformation) with 4 entries:

    "arthur-dent@hitchhikers-guide.galaxy"       ⟼ [arthur-dent@hitchhikers-guide.galaxy] (ContactInformation)
    "ford-prefect@hitchhikers-guide.galaxy"      ⟼ [ford-prefect@hitchhikers-guide.galaxy] (ContactInformation)
    "trillian-astra@hitchhikers-guide.galaxy"    ⟼ [trillian-astra@hitchhikers-guide.galaxy] (ContactInformation)
    "zaphod-beeblebrox@hitchhikers-guide.galaxy" ⟼ [zaphod-beeblebrox@hitchhikers-guide.galaxy] (ContactInformation)
```

This gave us four **`ContactInformation`** instances. Next we create **`Person`** instances and link each one to its **`ContactInformation`** instance. Finally we create one **`Membership`** instance per person and assign those memberships to the consortium.

```matlab
% Extract data to create a list of "Person" instances where each "Person" 
% instance will link to their respective "ContactInformation" instance

persons = openminds.core.Person.empty;

for iRow = 1:height(crewMembers)
    personRow = crewMembers(iRow,:);
    fullName = personRow.givenName + " " + personRow.familyName;

    persons(end+1) = openminds.core.Person( ...
        "id", createId(fullName), ...
        "givenName", personRow.givenName, ...
        "familyName", personRow.familyName, ...
        "preferredName", fullName, ...
        "alternateName", personRow.alternateName, ...
        "contactInformation", contacts(personRow.email)); %#ok<SAGROW>
end

% Create memberships for each person / crew member
memberships = openminds.core.miscellaneous.Membership.empty;
for i = 1:numel(persons)
    memberships(end+1) = openminds.core.miscellaneous.Membership( ...
        "member", persons(i)); %#ok<SAGROW>
end

% Add crew members to the crew
crew = consortia("Heart of Gold Spacecraft Crew");
crew.memberships = memberships;
```
# Add instances to collection and export collection

Now that we have all the instances, we can add them to the `collection`. It is sufficient to add the `crew` consortium. The collection will follow embedded and linked instances from there and add the detected metadata instances to the `Nodes` property.

```matlab
collection.add(crew)
disp(collection)
```

```matlabTextOutput
  Collection with properties:

             Name: "Crew Members"
      Description: "Crew members of the 'Heart of Gold' spacecraft"
            Nodes: dictionary (string ⟼ cell) with 9 entries
     LinkResolver: []
    MetadataStore: [0x0 openminds.internal.FileMetadataStore]
```

The `Nodes` dictionary contains 9 top\-level instances: 4 **`Person`** instances, 4 **`ContactInformation`** instances, and 1 **`Consortium`** instance. The **`Membership`** instances are embedded in the **`Consortium`**, so they are serialized as part of the consortium rather than as separate top\-level nodes.


```matlab
disp(collection.Nodes)
```

```matlabTextOutput
  dictionary (string ⟼ cell) with 9 entries:

    "_:arthur-dent@hitchhikers-guide.galaxy"       ⟼ {[arthur-dent@hitchhikers-guide.galaxy] (ContactInformation)}
    "_:arthur-dent"                                ⟼ {[Dent, Arthur] (Person)}
    "_:ford-prefect@hitchhikers-guide.galaxy"      ⟼ {[ford-prefect@hitchhikers-guide.galaxy] (ContactInformation)}
    "_:ford-prefect"                               ⟼ {[Prefect, Ford] (Person)}
    "_:trillian-astra@hitchhikers-guide.galaxy"    ⟼ {[trillian-astra@hitchhikers-guide.galaxy] (ContactInformation)}
    "_:tricia-marie-mcmillan"                      ⟼ {[McMillan, Tricia Marie] (Person)}
    "_:zaphod-beeblebrox@hitchhikers-guide.galaxy" ⟼ {[zaphod-beeblebrox@hitchhikers-guide.galaxy] (ContactInformation)}
    "_:zaphod-beeblebrox"                          ⟼ {[Beeblebrox, Zaphod] (Person)}
    "_:heart-of-gold-spacecraft-crew"              ⟼ {[Heart of Gold Spacecraft Crew] (Consortium)}
```

A note here: Since the collection holds a mix of different types, each type is inside a cell (as indicated by the curly brackets). In order to get an instance from the `Nodes`, we need to index into a cell object:

```matlab
if isMATLABReleaseOlderThan("R2023a")
    cellValue = collection.Nodes("_:arthur-dent");
    personRow = cellValue{1}
else
    personRow = collection.Nodes{"_:arthur-dent"} % Curly brace syntax introduced in R2023a
end
```

```matlabTextOutput
personRow = 
  Person (_:arthur-dent) with properties:

         alternateName: <missing>
     associatedAccount: [None] (AccountInformation)
    contactInformation: arthur-dent@hitchhikers-guide.galaxy (ContactInformation)
     digitalIdentifier: [None] (Any of: GenericIdentifier, ORCID)
            familyName: "Dent"
             givenName: "Arthur"
         preferredName: "Arthur Dent"

  Required Properties: preferredName

  Show all accessible properties of Person

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

```matlabTextOutput
{
  "@context": {
    "@vocab": "https://openminds.om-i.org/props/"
  },
  "@graph": [
    {
      "@id": "_:arthur-dent@hitchhikers-guide.galaxy",
      "@type": "https://openminds.om-i.org/types/ContactInformation",
      "email": "arthur-dent@hitchhikers-guide.galaxy"
    },
    {
      "@id": "_:arthur-dent",
      "@type": "https://openminds.om-i.org/types/Person",
      "contactInformation": [
        {
          "@id": "_:arthur-dent@hitchhikers-guide.galaxy"
        }
      ],
      "familyName": "Dent",
      "givenName": "Arthur",
      "preferredName": "Arthur Dent"
    },
    {
      "@id": "_:ford-prefect@hitchhikers-guide.galaxy",
      "@type": "https://openminds.om-i.org/types/ContactInformation",
      "email": "ford-prefect@hitchhikers-guide.galaxy"
    },
    {
      "@id": "_:ford-prefect",
      "@type": "https://openminds.om-i.org/types/Person",
      "contactInformation": [
        {
          "@id": "_:ford-prefect@hitchhikers-guide.galaxy"
        }
      ],
      "familyName": "Prefect",
      "givenName": "Ford",
      "preferredName": "Ford Prefect"
    },
    {
      "@id": "_:trillian-astra@hitchhikers-guide.galaxy",
      "@type": "https://openminds.om-i.org/types/ContactInformation",
      "email": "trillian-astra@hitchhikers-guide.galaxy"
    },
    {
      "@id": "_:tricia-marie-mcmillan",
      "@type": "https://openminds.om-i.org/types/Person",
      "alternateName": "Trillian Astra",
      "contactInformation": [
        {
          "@id": "_:trillian-astra@hitchhikers-guide.galaxy"
        }
      ],
      "familyName": "McMillan",
      "givenName": "Tricia Marie",
      "preferredName": "Tricia Marie McMillan"
    },
    {
      "@id": "_:zaphod-beeblebrox@hitchhikers-guide.galaxy",
      "@type": "https://openminds.om-i.org/types/ContactInformation",
      "email": "zaphod-beeblebrox@hitchhikers-guide.galaxy"
    },
    {
      "@id": "_:zaphod-beeblebrox",
      "@type": "https://openminds.om-i.org/types/Person",
      "contactInformation": [
        {
          "@id": "_:zaphod-beeblebrox@hitchhikers-guide.galaxy"
        }
      ],
      "familyName": "Beeblebrox",
      "givenName": "Zaphod",
      "preferredName": "Zaphod Beeblebrox"
    },
    {
      "@id": "_:heart-of-gold-spacecraft-crew",
      "@type": "https://openminds.om-i.org/types/Consortium",
      "fullName": "Heart of Gold Spacecraft Crew",
      "memberships": [
        {
          "member": [
            {
              "@id": "_:arthur-dent"
            }
          ],
          "@type": "https://openminds.om-i.org/types/Membership"
        },
        {
          "member": [
            {
              "@id": "_:ford-prefect"
            }
          ],
          "@type": "https://openminds.om-i.org/types/Membership"
        },
        {
          "member": [
            {
              "@id": "_:tricia-marie-mcmillan"
            }
          ],
          "@type": "https://openminds.om-i.org/types/Membership"
        },
        {
          "member": [
            {
              "@id": "_:zaphod-beeblebrox"
            }
          ],
          "@type": "https://openminds.om-i.org/types/Membership"
        }
      ]
    }
  ]
}
```
