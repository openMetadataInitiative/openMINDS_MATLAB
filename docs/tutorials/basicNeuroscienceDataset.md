<a id="T_1bb4"></a>

# Creating openMINDS Metadata: A Basic Introduction

This tutorial demonstrates how to create, link, and save metadata using the openMINDS MATLAB toolbox. We will create a simplified neuroscience dataset with subjects, contributors, organizations, and experimental details.

The openMINDS (Open Metadata Initiative for Neuroscience Data Structures) provides standardized metadata models for neuroscience data. This standardization facilitates data sharing, discovery, and reuse.

Please refer to the [openMINDS documentation](https://openminds-documentation.readthedocs.io/en/latest/schema_specifications.html) to learn more about the available metadata types.

This tutorial covers: 

<!-- Begin Toc -->

## Table of Contents
&#8195;[1. Creating a Metadata Collection](#H_589e)
 
&#8195;[2. Creating Basic Metadata Instances](#H_9d10)
 
&#8195;&#8195;[2.1 Create organization instances](#H_37a5)
 
&#8195;&#8195;[2.2 Create contact information instances](#H_5d03)
 
&#8195;&#8195;[2.3 Create person and affiliation instances](#H_500c)
 
&#8195;[3. Creating Dataset Metadata](#H_72ef)
 
&#8195;&#8195;[3.1 Create a DOI (Digital Object Identifier)](#H_704f)
 
&#8195;&#8195;[3.2 Create a license](#H_151d)
 
&#8195;&#8195;[3.3 Create a file repository](#H_25ed)
 
&#8195;&#8195;[3.4 Create a behavioral protocol](#H_3615)
 
&#8195;&#8195;[3.5 Create controlled terms](#H_727f)
 
&#8195;&#8195;[3.6 Create a custom term suggestion (for keywords that don't exist in controlled vocabularies)](#H_7923)
 
&#8195;&#8195;[3.7 Create dataset and dataset version](#H_99d7)
 
&#8195;[4. Creating Subject Metadata](#H_9f96)
 
&#8195;&#8195;[4.1 Create a species (strain)](#H_1f72)
 
&#8195;&#8195;[4.2 Create biological sex controlled term](#H_72ab)
 
&#8195;&#8195;[4.3 Create subject state attributes](#H_9593)
 
&#8195;&#8195;[4.4 Create a subject](#H_40d7)
 
&#8195;&#8195;[4.5 Create another subject](#H_6998)
 
&#8195;&#8195;[4.6 Create and add subject states for each of the subjects](#H_61c0)
 
&#8195;&#8195;[4.7 Link subjects to the dataset](#H_189d)
 
&#8195;[5. Adding Instances to Collection and Saving](#H_5378)
 
&#8195;&#8195;[5.1 Add the dataset version to the collection](#H_75d6)
 
&#8195;&#8195;[5.2 Save the collection to a JSON\-LD file](#H_28a1)
 
&#8195;&#8195;[5.3 Display the saved JSON-LD content](#H_0727)
 
&#8195;[6. Summary](#H_3f72)
 
<!-- End Toc -->
<a id="H_589e"></a>

# 1. Creating a Metadata Collection

We start by creating an empty metadata collection that will hold all our instances. A collection is a container for metadata instances.

```matlab
% Create an empty metadata collection
collection = openminds.Collection(...
    "Name", "Neuroscience Dataset Example", ...
    "Description", "A tutorial dataset for learning openMINDS metadata creation");


disp(collection)
```

```matlabTextOutput
  Collection with properties:


             Name: "Neuroscience Dataset Example"
      Description: "A tutorial dataset for learning openMINDS metadata creation"
            Nodes: dictionary with unset key and value types
    MetadataStore: [0x0 openminds.internal.FileMetadataStore]
```

<a id="H_9d10"></a>

# 2. Creating Basic Metadata Instances

Let us create instances for researchers, their contact information, and their organizations. The examples show two common construction patterns: using name\-value pairs in the constructor, and creating an empty instance before assigning properties with dot notation.

```matlab
% Define a utility function for creating instance IDs
createId = @(str) lower(sprintf('_:%s', replace(str, ' ', '-')));
```

<a id="H_37a5"></a>

## 2.1 Create organization instances
```matlab
% First approach: Using name-value pairs in the constructor
university = openminds.core.actors.Organization(...
    "id", createId("University of Neuroscience"), ...
    "name", "University of Neuroscience", ...
    "acronym", "UNS", ...
    "countryOfFormation", openminds.controlledterms.SovereignState("Germany"), ...
    "type", openminds.controlledterms.OrganizationType("legalEntity"));
```

```matlabTextOutput
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
```

```matlab


% Second approach: Create empty instance and set properties
researchCenter = openminds.core.actors.Organization();
```

```matlabTextOutput
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
```

```matlab
researchCenter.id = createId("Brain Research Center");
```

```matlabTextOutput
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
```

```matlab
researchCenter.name = "Brain Research Center";
```

```matlabTextOutput
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
```

```matlab
researchCenter.acronym = "BRC";
```

```matlabTextOutput
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
```

```matlab
researchCenter.countryOfFormation = openminds.controlledterms.SovereignState("Germany");
```

```matlabTextOutput
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
```

```matlab
researchCenter.type = openminds.controlledterms.OrganizationType("organizationalUnit");
```

```matlabTextOutput
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
```

```matlab
researchCenter.hasParent = university;
```

```matlabTextOutput
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
```

```matlab


% Display selected Organization fields:
fprintf("%s (%s)\n", university.name, university.acronym)
```

```matlabTextOutput
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
University of Neuroscience
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
 (UNS)
```

```matlab
fprintf("%s (%s)\n", researchCenter.name, researchCenter.acronym)
```

```matlabTextOutput
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Brain Research Center (BRC)
```

<a id="H_5d03"></a>

## 2.2 Create contact information instances
```matlab
contactPI = openminds.core.actors.ContactInformation(...
    'id', createId('contact-pi'), ...
    'email', 'pi@neuroscience.edu');
```

```matlabTextOutput
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
```

```matlab
contactPostdoc = openminds.core.actors.ContactInformation(...
    'id', createId('contact-postdoc'), ...
    'email', 'postdoc@neuroscience.edu');
```

```matlabTextOutput
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
```

```matlab
disp(contactPI)
```

```matlabTextOutput
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
  ContactInformation (_:contact-pi) with properties:
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
    
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
email
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
: 
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
"pi@neuroscience.edu"
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
  Required Properties: email
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
```

```matlab
disp(contactPostdoc)
```

```matlabTextOutput
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
  ContactInformation (_:contact-postdoc) with properties:

    email: "postdoc@neuroscience.edu"

  Required Properties: email
```

<a id="H_500c"></a>

## 2.3 Create person and affiliation instances

A **`Person`** describes an individual. The affiliation is represented as a separate **`Affiliation`** instance linking that person to an organization.

<a id="H_21D87695"></a>
```matlab
% Principal Investigator
pi = openminds.core.actors.Person(...
    "id", createId("jane-doe"), ...
    "givenName", "Jane", ...
    "familyName", "Doe", ...
    "preferredName", "Jane Doe", ...
    "contactInformation", contactPI);
```

```matlabTextOutput
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
```

```matlab


% Postdoc
postdoc = openminds.core.actors.Person(...
    "id", createId("john-smith"), ...
    "givenName", "John", ...
    "familyName", "Smith", ...
    "preferredName", "John Smith", ...
    "contactInformation", contactPostdoc);
```

```matlabTextOutput
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
```

```matlab


% Affiliations are represented separately from the Person instances
piAffiliation = openminds.core.actors.Affiliation(...
    "person", pi, ...
    "organization", university);
```

```matlabTextOutput
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
```

```matlab


postdocAffiliation = openminds.core.actors.Affiliation(...
    "person", postdoc, ...
    "organization", researchCenter);
```

```matlabTextOutput
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
```

```matlab


% Display the Person metadata instances:
disp(pi)
```

```matlabTextOutput
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
  Person (_:jane-doe) with properties:
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
         
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
alternateName
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
: 
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
[1x0 string]
     associatedAccount: [None] (AccountInformation)
    contactInformation: pi@neuroscience.edu (ContactInformation)
     
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
digitalIdentifier
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
: 
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
[1x0 DigitalIdentifier]
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
            
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
familyName
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
: 
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
"Doe"
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
             givenName: "Jane"
         preferredName: "Jane Doe"

  Required Properties: preferredName
```

```matlab
disp(postdoc)
```

```matlabTextOutput
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
  Person (_:john-smith) with properties:

         alternateName: [1x0 string]
     associatedAccount: [None] (AccountInformation)
    contactInformation: postdoc@neuroscience.edu (ContactInformation)
     
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
digitalIdentifier
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
: 
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
[1x0 DigitalIdentifier]
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
            
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
familyName
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
: 
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
"Smith"
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
             givenName: "John"
         preferredName: "John Smith"

  Required Properties: preferredName
```

<a id="H_72ef"></a>

# 3. Creating Dataset Metadata

Next we create metadata for the dataset and for one concrete dataset version. Contributor roles are represented with Contribution instances. Contributor affiliations are represented separately with Affiliation instances that link people to organizations.

<a id="H_704f"></a>

## 3.1 Create a DOI (Digital Object Identifier)
```matlab
doi = openminds.core.digitalidentifier.DOI(...
    'id', createId('dataset-doi'), ...
    'identifier', 'https://doi.org/10.1234/example.2023.001');
```

```matlabTextOutput
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
```

<a id="H_151d"></a>

## 3.2 Create a license

A **`License`** describes the conditions under which the dataset version can be reused. For this example, we create a small license instance directly.

```matlab
% Create a license manually for this example:
license = openminds.core.data.License(...
    "id", createId("cc-by-4"), ...
    "fullName", "Creative Commons Attribution 4.0 International", ...
    "shortName", "CC-BY-4.0", ...
    "legalCode", "https://creativecommons.org/licenses/by/4.0/legalcode", ...
    "webpage", "https://creativecommons.org/licenses/by/4.0");
```

```matlabTextOutput
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
```

```matlab


disp(license)
```

```matlabTextOutput
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
  License (_:cc-by-4) with properties:
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
     
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
fullName
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
: 
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
"Creative Commons Attribution 4.0 International"
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
    
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
legalCode: "https://creativecommons.org/licenses/by/4.0/legalcode"
    shortName: "CC-BY-4.0"
      webpage: "https://creativecommons.org/licenses/by/4.0"

  Required Properties: fullName, legalCode, shortName
```

```matlab
% The variable "license" now holds the reusable License instance.
```

<a id="H_25ed"></a>

## 3.3 Create a file repository
<a id="H_20CDEE8F"></a>
Note: This is only relevant if data is stored in external repository. If a dataset is submitted via EBRAINS, the file repository is created and added as part of the curation process

```matlab
repository = openminds.core.data.FileRepository(...
    'id', createId('dataset-repository'), ...
    'IRI', 'https://example-repository.org/datasets/123', ...
    'name', 'Example Dataset Repository', ...
    'hostedBy', university);
```

```matlabTextOutput
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
```

<a id="H_3615"></a>

## 3.4 Create a behavioral protocol
```matlab
protocol = openminds.core.research.BehavioralProtocol(...
    'id', createId('visual-task-protocol'), ...
    'name', 'Visual Go/NoGo Task', ...
    'description', ['Mice were trained to discriminate visual stimuli. ', ...
    'Each stimulus was associated with a specific outcome (reward, nothing, or punishment).']);
```

```matlabTextOutput
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
```

<a id="H_727f"></a>

## 3.5 Create controlled terms

Controlled terms are metadata types with a corresponding terminology developed by the Open Metadata Initiative, available here: [https://github.com/openMetadataInitiative/openMINDS\_instances](https://github.com/openMetadataInitiative/openMINDS_instances)

To see a list of available instances, use the **`listInstances`**. 

**Note**: ControlledTerm types accept the instance names as an input to the class constructor directly (See below for examples).

```matlab
openminds.controlledterms.PreparationType.listInstances()
```

```matlabTextOutput
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
ans = 6x1 string
"exVivo"    
"inSilico"  
"inSitu"    
"inUtero"   
"inVitro"   
"inVivo"    

Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
```

```matlab
% These are predefined terms from controlled vocabularies
preparationType = openminds.controlledterms.PreparationType("inVivo");
```

```matlabTextOutput
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
```

```matlab


dataType = openminds.controlledterms.SemanticDataType("experimentalData");
```

```matlabTextOutput
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
```

```matlab


experimentalApproach1 = openminds.controlledterms.ExperimentalApproach("behavior");
```

```matlabTextOutput
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
```

```matlab
experimentalApproach2 = openminds.controlledterms.ExperimentalApproach("electrophysiology");
```

```matlabTextOutput
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
```

```matlab


technique = openminds.controlledterms.Technique("extracellularElectrophysiology");
```

```matlabTextOutput
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
```

```matlab


ethicsJurisdiction = openminds.controlledterms.SovereignState("Germany");
```

```matlabTextOutput
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
```

```matlab


accessibility = openminds.core.miscellaneous.Accessibility(...
    "channel", openminds.controlledterms.AccessChannel("virtualAccess"), ...
    "eligibility", openminds.controlledterms.AccessEligibilityType("openAccess"), ...
    "form", openminds.controlledterms.AccessForm("directAccess"), ...
    "paymentModel", openminds.controlledterms.PaymentModelType("zero-costPaymentModel"), ...
    "process", openminds.controlledterms.AccessProcessType("immediateAccess"));
```

```matlabTextOutput
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
```

```matlab


contributionTypeAuthor = openminds.controlledterms.ContributionType("authoring");
```

```matlabTextOutput
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
```

```matlab
contributionTypeCustodian = openminds.controlledterms.ContributionType("custodianship");
```

```matlabTextOutput
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
```

<a id="H_7923"></a>

## 3.6 Create a custom term suggestion (for keywords that don't exist in controlled vocabularies)
```matlab
customKeyword = openminds.controlledterms.TermSuggestion(...
    'id', createId('custom-brain-region'), ...
    'name', 'visual cortex');
```

```matlabTextOutput
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
```

<a id="H_99d7"></a>

## 3.7 Create dataset and dataset version

The **`Dataset`** instance stores version\-independent metadata. The **`DatasetVersion`** instance stores metadata for this specific release, including accessibility, release date, protocols, studied specimens, and version\-specific documentation.

```matlab
documentation = openminds.core.miscellaneous.WebResource(...
    "id", createId("dataset-documentation"), ...
    "IRI", "https://example-repository.org/datasets/123/documentation");
```

```matlabTextOutput
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
```

```matlab


authorContribution = openminds.core.actors.Contribution(...
    "contributor", [pi, postdoc], ...
    "type", contributionTypeAuthor);
```

```matlabTextOutput
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
```

```matlab


custodianContribution = openminds.core.actors.Contribution(...
    "contributor", pi, ...
    "type", contributionTypeCustodian);
```

```matlabTextOutput
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
```

```matlab


contributions = [authorContribution, custodianContribution];
```

```matlabTextOutput
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
```

```matlab
contributorAffiliations = [piAffiliation, postdocAffiliation];
```

```matlabTextOutput
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
```

```matlab


dataset = openminds.core.products.Dataset(...
    "id", createId("example-dataset"), ...
    "fullName", "Neural activity during visual discrimination task", ...
    "shortName", "Visual Task Dataset", ...
    "description", "This dataset contains neural recordings from mice " + ...
    "performing a visual discrimination task.", ...
    "contribution", contributions, ...
    "contributorAffiliation", contributorAffiliations);
```

```matlabTextOutput
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
```

```matlab


datasetVersion = openminds.core.products.DatasetVersion(...
    "id", createId("example-dataset-v1"), ...
    "fullName", "Neural activity during visual discrimination task", ...
    "shortName", "Visual Task Dataset", ...
    "versionIdentifier", "v1", ...
    "accessibility", accessibility, ...
    "contribution", contributions, ...
    "contributorAffiliation", contributorAffiliations, ...
    "description", "This dataset contains neural recordings from mice " + ...
    "performing a visual discrimination task.", ...
    "digitalIdentifier", doi, ...
    "documentation", documentation, ...
    "ethicsJurisdiction", ethicsJurisdiction, ...
    "experimentalApproach", [experimentalApproach1, experimentalApproach2], ...
    "usageCondition", license, ...
    "preparationType", preparationType, ...
    "repository", repository, ...
    "dataType", dataType, ...
    "technique", technique, ...
    "protocol", protocol, ...
    "keyword", customKeyword, ...
    "isVersionOf", dataset, ...
    "releaseDate", datetime(2023, 1, 1), ...
    "versionSpecification", "This is the first version of this dataset.");
```

```matlabTextOutput
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
```

```matlab


fprintf("Created dataset version: %s (%s)\n", ...
    datasetVersion.fullName, datasetVersion.versionIdentifier)
```

```matlabTextOutput
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Created dataset version: 
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Neural activity during visual discrimination task
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
 (
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
v1
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
)
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
```

<a id="H_9f96"></a>

# 4. Creating Subject Metadata

Next we create subjects and their states, then link the studied specimens to the dataset version.

<a id="H_1f72"></a>

## 4.1 Create a species (strain)
```matlab
strain = openminds.core.research.Strain(...
    'id', createId('c57bl6j-strain'), ...
    'name', 'C57BL/6J', ...
    'species', openminds.controlledterms.Species('musMusculus'));
```

```matlabTextOutput
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
```

<a id="H_72ab"></a>

## 4.2 Create biological sex controlled term
```matlab
biologicalSex = openminds.controlledterms.BiologicalSex('male');
```

```matlabTextOutput
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
```

<a id="H_9593"></a>

## 4.3 Create subject state attributes
```matlab
subjectAttribute1 = openminds.controlledterms.SubjectAttribute('alive');
```

```matlabTextOutput
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
```

```matlab
subjectAttribute2 = openminds.controlledterms.SubjectAttribute('awake');
```

```matlabTextOutput
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
```

```matlab


ageCategory = openminds.controlledterms.AgeCategory('adult');
```

```matlabTextOutput
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
```

<a id="H_40d7"></a>

## 4.4 Create a subject
```matlab
subject1 = openminds.core.research.Subject(...
    'id', createId('subject1'), ...
    'lookupLabel', 'Subject1', ...
    'biologicalSex', biologicalSex, ...
    'species', strain, ...
    'internalIdentifier', 'S1');
```

```matlabTextOutput
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
```

<a id="H_6998"></a>

## 4.5 Create another subject
```matlab
subject2 = openminds.core.research.Subject(...
    'id', createId('subject2'), ...
    'lookupLabel', 'Subject2', ...
    'biologicalSex', biologicalSex, ...
    'species', strain, ...
    'internalIdentifier', 'S2');
```

```matlabTextOutput
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
```

<a id="H_61c0"></a>

## 4.6 Create and add subject states for each of the subjects
```matlab
subjectState1 = openminds.core.research.SubjectState(...
    'id', createId('subject1-state'), ...
    'lookupLabel', 'Subject1-state', ...
    'ageCategory', ageCategory, ...
    'attribute', [subjectAttribute1, subjectAttribute2], ...
    'internalIdentifier', 'Subject1-state-01');
```

```matlabTextOutput
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
```

```matlab
subject1.studiedState = subjectState1;
```

```matlabTextOutput
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
```

```matlab


subjectState2 = openminds.core.research.SubjectState(...
    'id', createId('subject2-state'), ...
    'lookupLabel', 'Subject2-state', ...
    'ageCategory', "adolescent", ...
    'attribute', [subjectAttribute1, subjectAttribute2], ...
    'internalIdentifier', 'Subject2-state-01');
```

```matlabTextOutput
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
```

```matlab
subject2.studiedState = subjectState2;
```

```matlabTextOutput
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
```

```matlab


% Display the Subject metadata
disp(subject1);
```

```matlabTextOutput
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
  Subject (_:subject1) with properties:
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
         
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
biologicalSex
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
: 
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
male (BiologicalSex)
    internalIdentifier: "S1"
              isPartOf: [None] (SubjectGroup)
           lookupLabel: "Subject1"
               species: C57BL/6J (Strain)
          studiedState: Subject1-state (SubjectState)

  Required Properties: species, studiedState
```

```matlab
disp(subject2);
```

```matlabTextOutput
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
  Subject (_:subject2) with properties:

         
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
biologicalSex
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
: 
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
male (BiologicalSex)
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
    
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
internalIdentifier
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
: 
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
"S2"
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
              isPartOf: [None] (SubjectGroup)
           lookupLabel: "Subject2"
               species: C57BL/6J (Strain)
          studiedState: Subject2-state (SubjectState)

  Required Properties: species, studiedState
```

<a id="H_189d"></a>

## 4.7 Link subjects to the dataset
```matlab
datasetVersion.studiedSpecimen = [subject1, subject2];
```

```matlabTextOutput
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
```

```matlab


% Display a short confirmation for the updated dataset version:
fprintf("Dataset version now links to %d studied specimens.\n", ...
    numel(datasetVersion.studiedSpecimen))
```

```matlabTextOutput
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Dataset version now links to 2 studied specimens.
```

<a id="H_5378"></a>

# 5. Adding Instances to Collection and Saving

Finally, we add the dataset version to the collection and save the detected metadata graph to a file.

<a id="H_75d6"></a>

## 5.1 Add the dataset version to the collection
```matlab
% Note: The collection will automatically include all linked instances
collection.add(datasetVersion);
```

```matlabTextOutput
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
```

```matlab


disp(collection);
```

```matlabTextOutput
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
  Collection with properties:
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
             
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Name
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
: 
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
"Neuroscience Dataset Example"
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
      Description: "A tutorial dataset for learning openMINDS metadata creation"
            Nodes: dictionary (string --> cell) with 41 entries
    MetadataStore: [0x0 openminds.internal.FileMetadataStore]
```

<a id="H_28a1"></a>

## 5.2 Save the collection to a JSON\-LD file
```matlab
% Define the save path (in the current directory)
savePath = fullfile(pwd, 'example_metadata.jsonld');
```

```matlabTextOutput
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
```

```matlab
collection.save(savePath);
```

```matlabTextOutput
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
```

```matlab


disp(['Saved metadata to: ', savePath]);
```

```matlabTextOutput
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Saved metadata to: /home/runner/work/openMINDS_MATLAB/openMINDS_MATLAB/code/livescripts/example_metadata.jsonld
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
```

<a id="H_0727"></a>

## 5.3 Display the saved JSON-LD content
```matlab
jsonContent = fileread(savePath);
```

```matlabTextOutput
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
```

```matlab
disp(jsonContent);
```

```matlabTextOutput
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
{
  "@context": {
    "@vocab": "https://openminds.om-i.org/props/"
  },
  "@graph": [
    {
      "@id": "_:brain-research-center",
      "@type": "https://openminds.om-i.org/types/Organization",
      "acronym": "BRC",
      "countryOfFormation": {
        "@id": "https://openminds.om-i.org/instances/SovereignState/Germany"
      },
      "hasParent": [
        {
          "@id": "_:university-of-neuroscience"
        }
      ],
      "name": "Brain Research Center",
      "type": {
        "@id": "https://openminds.om-i.org/instances/organizationType/organizationalUnit"
      }
    },
    {
      "@id": "_:1",
      "@type": "https://openminds.om-i.org/types/Accessibility",
      "channel": {
        "@id": "https://openminds.om-i.org/instances/accessChannel/virtualAccess"
      },
      "eligibility": {
        "@id": "https://openminds.om-i.org/instances/accessEligibilityType/openAccess"
      },
      "form": {
        "@id": "https://openminds.om-i.org/instances/accessForm/directAccess"
      },
      "paymentModel": [
        {
          "@id": "https://openminds.om-i.org/instances/paymentModelType/zero-costPaymentModel"
        }
      ],
      "process": {
        "@id": "https://openminds.om-i.org/instances/accessProcessType/immediateAccess"
      }
    },
    {
      "@id": "_:c57bl6j-strain",
      "@type": "https://openminds.om-i.org/types/Strain",
      "name": "C57BL/6J",
      "species": {
        "@id": "https://openminds.om-i.org/instances/species/musMusculus"
      }
    },
    {
      "@id": "_:cc-by-4",
      "@type": "https://openminds.om-i.org/types/License",
      "fullName": "Creative Commons Attribution 4.0 International",
      "legalCode": "https://creativecommons.org/licenses/by/4.0/legalcode",
      "shortName": "CC-BY-4.0",
      "webpage": [
        "https://creativecommons.org/licenses/by/4.0"
      ]
    },
    {
      "@id": "_:contact-pi",
      "@type": "https://openminds.om-i.org/types/ContactInformation",
      "email": [
        "pi@neuroscience.edu"
      ]
    },
    {
      "@id": "_:contact-postdoc",
      "@type": "https://openminds.om-i.org/types/ContactInformation",
      "email": [
        "postdoc@neuroscience.edu"
      ]
    },
    {
      "@id": "_:custom-brain-region",
      "@type": "https://openminds.om-i.org/types/TermSuggestion",
      "name": "visual cortex"
    },
    {
      "@id": "_:dataset-documentation",
      "@type": "https://openminds.om-i.org/types/WebResource",
      "IRI": "https://example-repository.org/datasets/123/documentation"
    },
    {
      "@id": "_:dataset-doi",
      "@type": "https://openminds.om-i.org/types/DOI",
      "identifier": "https://doi.org/10.1234/example.2023.001"
    },
    {
      "@id": "_:dataset-repository",
      "@type": "https://openminds.om-i.org/types/FileRepository",
      "IRI": "https://example-repository.org/datasets/123",
      "hostedBy": {
        "@id": "_:university-of-neuroscience"
      },
      "name": "Example Dataset Repository"
    },
    {
      "@id": "_:example-dataset",
      "@type": "https://openminds.om-i.org/types/Dataset",
      "contribution": [
        {
          "contributor": [
            {
              "@id": "_:jane-doe"
            },
            {
              "@id": "_:john-smith"
            }
          ],
          "type": {
            "@id": "https://openminds.om-i.org/instances/contributionType/authoring"
          },
          "@type": "https://openminds.om-i.org/types/Contribution"
        },
        {
          "contributor": [
            {
              "@id": "_:jane-doe"
            }
          ],
          "type": {
            "@id": "https://openminds.om-i.org/instances/contributionType/custodianship"
          },
          "@type": "https://openminds.om-i.org/types/Contribution"
        }
      ],
      "contributorAffiliation": [
        {
          "organization": [
            {
              "@id": "_:university-of-neuroscience"
            }
          ],
          "person": {
            "@id": "_:jane-doe"
          },
          "@type": "https://openminds.om-i.org/types/Affiliation"
        },
        {
          "organization": [
            {
              "@id": "_:brain-research-center"
            }
          ],
          "person": {
            "@id": "_:john-smith"
          },
          "@type": "https://openminds.om-i.org/types/Affiliation"
        }
      ],
      "description": "This dataset contains neural recordings from mice performing a visual discrimination task.",
      "fullName": "Neural activity during visual discrimination task",
      "shortName": "Visual Task Dataset"
    },
    {
      "@id": "_:example-dataset-v1",
      "@type": "https://openminds.om-i.org/types/DatasetVersion",
      "accessibility": {
        "@id": "_:1"
      },
      "contribution": [
        {
          "contributor": [
            {
              "@id": "_:jane-doe"
            },
            {
              "@id": "_:john-smith"
            }
          ],
          "type": {
            "@id": "https://openminds.om-i.org/instances/contributionType/authoring"
          },
          "@type": "https://openminds.om-i.org/types/Contribution"
        },
        {
          "contributor": [
            {
              "@id": "_:jane-doe"
            }
          ],
          "type": {
            "@id": "https://openminds.om-i.org/instances/contributionType/custodianship"
          },
          "@type": "https://openminds.om-i.org/types/Contribution"
        }
      ],
      "contributorAffiliation": [
        {
          "organization": [
            {
              "@id": "_:university-of-neuroscience"
            }
          ],
          "person": {
            "@id": "_:jane-doe"
          },
          "@type": "https://openminds.om-i.org/types/Affiliation"
        },
        {
          "organization": [
            {
              "@id": "_:brain-research-center"
            }
          ],
          "person": {
            "@id": "_:john-smith"
          },
          "@type": "https://openminds.om-i.org/types/Affiliation"
        }
      ],
      "dataType": [
        {
          "@id": "https://openminds.om-i.org/instances/semanticDataType/experimentalData"
        }
      ],
      "description": "This dataset contains neural recordings from mice performing a visual discrimination task.",
      "digitalIdentifier": {
        "@id": "_:dataset-doi"
      },
      "documentation": {
        "@id": "_:dataset-documentation"
      },
      "ethicsJurisdiction": {
        "@id": "https://openminds.om-i.org/instances/SovereignState/Germany"
      },
      "experimentalApproach": [
        {
          "@id": "https://openminds.om-i.org/instances/experimentalApproach/behavior"
        },
        {
          "@id": "https://openminds.om-i.org/instances/experimentalApproach/electrophysiology"
        }
      ],
      "fullName": "Neural activity during visual discrimination task",
      "isVersionOf": {
        "@id": "_:example-dataset"
      },
      "keyword": [
        {
          "@id": "_:custom-brain-region"
        }
      ],
      "preparationType": [
        {
          "@id": "https://openminds.om-i.org/instances/preparationType/inVivo"
        }
      ],
      "protocol": [
        {
          "@id": "_:visual-task-protocol"
        }
      ],
      "releaseDate": "2023-01-01",
      "repository": {
        "@id": "_:dataset-repository"
      },
      "shortName": "Visual Task Dataset",
      "studiedSpecimen": [
        {
          "@id": "_:subject1"
        },
        {
          "@id": "_:subject2"
        }
      ],
      "technique": [
        {
          "@id": "https://openminds.om-i.org/instances/technique/extracellularElectrophysiology"
        }
      ],
      "usageCondition": [
        {
          "@id": "_:cc-by-4"
        }
      ],
      "versionIdentifier": "v1",
      "versionSpecification": "This is the first version of this dataset."
    },
    {
      "@id": "_:jane-doe",
      "@type": "https://openminds.om-i.org/types/Person",
      "contactInformation": {
        "@id": "_:contact-pi"
      },
      "familyName": "Doe",
      "givenName": "Jane",
      "preferredName": "Jane Doe"
    },
    {
      "@id": "_:john-smith",
      "@type": "https://openminds.om-i.org/types/Person",
      "contactInformation": {
        "@id": "_:contact-postdoc"
      },
      "familyName": "Smith",
      "givenName": "John",
      "preferredName": "John Smith"
    },
    {
      "@id": "_:subject1",
      "@type": "https://openminds.om-i.org/types/Subject",
      "biologicalSex": {
        "@id": "https://openminds.om-i.org/instances/biologicalSex/male"
      },
      "internalIdentifier": "S1",
      "lookupLabel": "Subject1",
      "species": {
        "@id": "_:c57bl6j-strain"
      },
      "studiedState": [
        {
          "@id": "_:subject1-state"
        }
      ]
    },
    {
      "@id": "_:subject1-state",
      "@type": "https://openminds.om-i.org/types/SubjectState",
      "ageCategory": {
        "@id": "https://openminds.om-i.org/instances/ageCategory/adult"
      },
      "attribute": [
        {
          "@id": "https://openminds.om-i.org/instances/subjectAttribute/alive"
        },
        {
          "@id": "https://openminds.om-i.org/instances/subjectAttribute/awake"
        }
      ],
      "internalIdentifier": "Subject1-state-01",
      "lookupLabel": "Subject1-state"
    },
    {
      "@id": "_:subject2",
      "@type": "https://openminds.om-i.org/types/Subject",
      "biologicalSex": {
        "@id": "https://openminds.om-i.org/instances/biologicalSex/male"
      },
      "internalIdentifier": "S2",
      "lookupLabel": "Subject2",
      "species": {
        "@id": "_:c57bl6j-strain"
      },
      "studiedState": [
        {
          "@id": "_:subject2-state"
        }
      ]
    },
    {
      "@id": "_:subject2-state",
      "@type": "https://openminds.om-i.org/types/SubjectState",
      "ageCategory": {
        "@id": "https://openminds.om-i.org/instances/ageCategory/adolescent"
      },
      "attribute": [
        {
          "@id": "https://openminds.om-i.org/instances/subjectAttribute/alive"
        },
        {
          "@id": "https://openminds.om-i.org/instances/subjectAttribute/awake"
        }
      ],
      "internalIdentifier": "Subject2-state-01",
      "lookupLabel": "Subject2-state"
    },
    {
      "@id": "_:university-of-neuroscience",
      "@type": "https://openminds.om-i.org/types/Organization",
      "acronym": "UNS",
      "countryOfFormation": {
        "@id": "https://openminds.om-i.org/instances/SovereignState/Germany"
      },
      "name": "University of Neuroscience",
      "type": {
        "@id": "https://openminds.om-i.org/instances/organizationType/legalEntity"
      }
    },
    {
      "@id": "_:visual-task-protocol",
      "@type": "https://openminds.om-i.org/types/BehavioralProtocol",
      "description": "Mice were trained to discriminate visual stimuli. Each stimulus was associated with a specific outcome (reward, nothing, or punishment).",
      "name": "Visual Go/NoGo Task"
    },
    {
      "@id": "https://openminds.om-i.org/instances/SovereignState/Germany",
      "@type": "https://openminds.om-i.org/types/SovereignState",
      "definition": "Country in Central Europe. [auto-generated from 'schema:description' property of the [Wikidata entity](http://www.wikidata.org/entity/Q183)]",
      "name": "Germany",
      "preferredCrossReference": "http://www.wikidata.org/entity/Q183",
      "synonym": [
        "BR Deutschland",
        "BRD",
        "Bundesrepublik Deutschland",
        "DE",
        "de",
        "DEU",
        "Deutschland",
        "Federal Republic of Germany",
        "GER"
      ]
    },
    {
      "@id": "https://openminds.om-i.org/instances/accessChannel/virtualAccess",
      "@type": "https://openminds.om-i.org/types/AccessChannel",
      "definition": "Refers to the ability of users to connect to, interact with, and utilize resources, systems, or other individuals remotely via digital interfaces.",
      "name": "virtual access",
      "synonym": [
        "digital access",
        "online access"
      ]
    },
    {
      "@id": "https://openminds.om-i.org/instances/accessEligibilityType/openAccess",
      "@type": "https://openminds.om-i.org/types/AccessEligibilityType",
      "definition": "Access without prior registration, authentication, or authorisation.",
      "name": "open access"
    },
    {
      "@id": "https://openminds.om-i.org/instances/accessForm/directAccess",
      "@type": "https://openminds.om-i.org/types/AccessForm",
      "definition": "Users interact directly with the product or service through integrated interfaces, or authorised environments.",
      "name": "direct access"
    },
    {
      "@id": "https://openminds.om-i.org/instances/accessProcessType/immediateAccess",
      "@type": "https://openminds.om-i.org/types/AccessProcessType",
      "definition": "Automatic access upon acceptance of the applicable terms.",
      "name": "immediate access"
    },
    {
      "@id": "https://openminds.om-i.org/instances/ageCategory/adolescent",
      "@type": "https://openminds.om-i.org/types/AgeCategory",
      "definition": "'Adolescent' categorizes a transitional life cycle stage of growth and development between childhood and adulthood, often described as 'puberty'.",
      "name": "adolescent",
      "synonym": [
        "puberty"
      ]
    },
    {
      "@id": "https://openminds.om-i.org/instances/ageCategory/adult",
      "@type": "https://openminds.om-i.org/types/AgeCategory",
      "definition": "'Adult' categorizes the life cycle stage of an animal or human that reached sexual maturity.",
      "name": "adult",
      "otherOntologyIdentifier": [
        "http://uri.interlex.org/base/ilx_0729043"
      ],
      "preferredOntologyIdentifier": "http://purl.obolibrary.org/obo/UBERON_0000113",
      "synonym": [
        "adult stage",
        "post-juvenile adult",
        "post-juvenile adult stage"
      ]
    },
    {
      "@id": "https://openminds.om-i.org/instances/biologicalSex/male",
      "@type": "https://openminds.om-i.org/types/BiologicalSex",
      "definition": "Biological sex that produces sperm cells (spermatozoa).",
      "description": "A male organism typically has the capacity to produce relatively small, usually mobile gametes (reproductive cells), called sperm cells (or spermatozoa). In the process of fertilization, these sperm cells fuse with a larger, usually immobile female gamete, called egg cell (or ovum).",
      "name": "male",
      "otherOntologyIdentifier": [
        "http://uri.interlex.org/base/ilx_0106489"
      ],
      "preferredOntologyIdentifier": "http://purl.obolibrary.org/obo/PATO_0000384"
    },
    {
      "@id": "https://openminds.om-i.org/instances/contributionType/authoring",
      "@type": "https://openminds.om-i.org/types/ContributionType",
      "definition": "A contribution type of a role-bearing entity realized by creating textual, visual, or other expressive intellectual content about or for a target entity.",
      "name": "authoring"
    },
    {
      "@id": "https://openminds.om-i.org/instances/contributionType/custodianship",
      "@type": "https://openminds.om-i.org/types/ContributionType",
      "definition": "A contribution type of a role-bearing entity realized by assuming responsibility for the long-term stewardship and oversight of a target entity.",
      "name": "custodianship"
    },
    {
      "@id": "https://openminds.om-i.org/instances/experimentalApproach/behavior",
      "@type": "https://openminds.om-i.org/types/ExperimentalApproach",
      "definition": "Any experimental approach focused on the mechanical activity or cognitive processes underlying mechanical activity of living organisms often in response to external sensory stimuli.",
      "name": "behavior",
      "otherOntologyIdentifier": [
        "http://uri.interlex.org/tgbugs/uris/readable/modality/Behavior"
      ],
      "preferredOntologyIdentifier": "http://uri.interlex.org/base/ilx_0739413",
      "synonym": [
        "behavioral approach"
      ]
    },
    {
      "@id": "https://openminds.om-i.org/instances/experimentalApproach/electrophysiology",
      "@type": "https://openminds.om-i.org/types/ExperimentalApproach",
      "definition": "Any experimental approach focused on electrical phenomena associated with living systems, most notably the nervous system, cardiac system, and musculoskeletal system.",
      "name": "electrophysiology",
      "otherOntologyIdentifier": [
        "http://uri.interlex.org/tgbugs/uris/readable/modality/Electrophysiology"
      ],
      "preferredOntologyIdentifier": "http://uri.interlex.org/base/ilx_0741202"
    },
    {
      "@id": "https://openminds.om-i.org/instances/organizationType/legalEntity",
      "@type": "https://openminds.om-i.org/types/OrganizationType",
      "definition": "An organization classified as a type of legal entity recognized within a specific legal system.",
      "name": "legal entity",
      "preferredCrossReference": "https://www.wikidata.org/entity/Q10541491"
    },
    {
      "@id": "https://openminds.om-i.org/instances/organizationType/organizationalUnit",
      "@type": "https://openminds.om-i.org/types/OrganizationType",
      "definition": "A distinct unit within a larger organization.",
      "name": "organizational unit"
    },
    {
      "@id": "https://openminds.om-i.org/instances/paymentModelType/zero-costPaymentModel",
      "@type": "https://openminds.om-i.org/types/PaymentModelType",
      "definition": "No payment is required for any billable units (entitlement, consumption, event, monetary value, outcome, or capacity units).",
      "name": "zero-cost payment model"
    },
    {
      "@id": "https://openminds.om-i.org/instances/preparationType/inVivo",
      "@type": "https://openminds.om-i.org/types/PreparationType",
      "definition": "Something happening or existing inside a living body.",
      "name": "in vivo",
      "otherOntologyIdentifier": [
        "http://uri.interlex.org/tgbugs/uris/indexes/ontologies/methods/89"
      ],
      "preferredOntologyIdentifier": "http://uri.interlex.org/base/ilx_0739622",
      "synonym": [
        "in vivo technique"
      ]
    },
    {
      "@id": "https://openminds.om-i.org/instances/semanticDataType/experimentalData",
      "@type": "https://openminds.om-i.org/types/SemanticDataType",
      "name": "experimental data"
    },
    {
      "@id": "https://openminds.om-i.org/instances/species/musMusculus",
      "@type": "https://openminds.om-i.org/types/Species",
      "definition": "The species *Mus musculus* (house mouse) belongs to the family of *muridae* (murids).",
      "name": "Mus musculus",
      "otherOntologyIdentifier": [
        "http://uri.interlex.org/base/ilx_0107134"
      ],
      "preferredCrossReference": "https://knowledge-space.org/wiki/NCBITaxon:10090#mouse",
      "preferredOntologyIdentifier": "http://purl.obolibrary.org/obo/NCBITaxon_10090",
      "synonym": [
        "house mouse",
        "mouse"
      ]
    },
    {
      "@id": "https://openminds.om-i.org/instances/subjectAttribute/alive",
      "@type": "https://openminds.om-i.org/types/SubjectAttribute",
      "definition": "An organism that is not dead.",
      "name": "alive"
    },
    {
      "@id": "https://openminds.om-i.org/instances/subjectAttribute/awake",
      "@type": "https://openminds.om-i.org/types/SubjectAttribute",
      "definition": "A temporary state of an organism in which it is fully alert and aware.",
      "name": "awake"
    },
    {
      "@id": "https://openminds.om-i.org/instances/technique/extracellularElectrophysiology",
      "@type": "https://openminds.om-i.org/types/Technique",
      "definition": "In 'extracellular electrophysiology' electrodes are inserted into living tissue, but remain outside the cells in the extracellular environment to measure or stimulate electrical activity coming from adjacent cells, usually neurons.",
      "name": "extracellular electrophysiology"
    }
  ]
}
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
```

<a id="H_3f72"></a>

# 6. Summary

In this tutorial, we've learned how to: 

1. Create a metadata collection
2. Create various metadata instances (people, organizations, etc.)
3. Link people, organizations, contributions, affiliations, and dataset metadata
4. Use controlled terms from predefined vocabularies
5. Create custom term suggestions
6. Add instances to a collection
7. Save the collection to a JSON\-LD file

This provides a foundation for creating more complex metadata for neuroscience datasets using the openMINDS MATLAB toolbox.