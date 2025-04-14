
<a name="T_8111963C"></a>
# <span style="color:rgb(213,80,0)">Creating openMINDS Metadata: A Basic Introduction</span>

This tutorial demonstrates how to create, link, and save metadata using the openMINDS MATLAB toolbox. We'll create a simplified neuroscience dataset with subjects, researchers, and experimental details.


The openMINDS (Open Metadata Initiative for Neuroscience Data Structures) provides standardized metadata models for neuroscience data. This standardization facilitates data sharing, discovery, and reuse.


Please refer to the [openMINDS documentation](https://openminds-documentation.readthedocs.io/en/latest/schema_specifications.html) to learn more about the available metadata types.


This tutorial covers: 

<a name="beginToc"></a>
## Table of Contents
[1. Creating a Metadata Collection](#H_D94A2910)
 
[2. Creating Basic Metadata Instances](#H_811913EA)
 
&emsp;[2.1 Create organization instances](#H_2B8616D2)
 
&emsp;[2.2 Create contact information instances](#H_326DAA87)
 
&emsp;[2.3 Create person instances with affiliations](#H_83D5A6A9)
 
[3. Creating Dataset Metadata](#H_BA8C6418)
 
&emsp;[3.1 Create a DOI (Digital Object Identifier)](#H_FECC0736)
 
&emsp;[3.2 Create a license](#H_D8624084)
 
&emsp;[3.3 Create a file repository](#H_8E41DC07)
 
&emsp;[3.4 Create a behavioral protocol](#H_A9E27051)
 
&emsp;[3.5 Create controlled terms](#H_31DD0816)
 
&emsp;[3.6 Create a custom term suggestion (for keywords that don't exist in controlled vocabularies)](#H_FAF6F121)
 
&emsp;[3.7 Create the dataset version](#H_D54334A9)
 
[4. Creating Subject Metadata](#H_FC44336C)
 
&emsp;[4.1 Create a species (strain)](#H_FE1CCF54)
 
&emsp;[4.2 Create biological sex controlled term](#H_DEDF3B40)
 
&emsp;[4.3 Create subject state attributes](#H_46CDB34E)
 
&emsp;[4.4 Create a subject](#H_C964FE25)
 
&emsp;[4.5 Create another subject](#H_91A556DE)
 
&emsp;[4.6 Create and add subject states for each of the subjects](#H_48F6094F)
 
&emsp;[4.7 Link subjects to the dataset](#H_75B707F7)
 
[5. Adding Instances to Collection and Saving](#H_C34C62C9)
 
&emsp;[5.1 Add the dataset to the collection](#H_02873F7B)
 
&emsp;[5.2 Save the collection to a JSON-LD file](#H_7C761973)
 
&emsp;[5.3 Display the saved JSON-LD content](#H_65639D51)
 
[6. Summary](#H_98425D04)
 
<a name="endToc"></a>
<a name="H_D94A2910"></a>
# 1. Creating a Metadata Collection

We start by creating an empty metadata collection that will hold all our instances. A collection is a container for metadata instances.

```matlab
% Create an empty metadata collection
collection = openminds.Collection(...
    "Name", "Neuroscience Dataset Example", ...
    "Description", "A tutorial dataset for learning openMINDS metadata creation");

disp(collection)
```

```TextOutput
  Collection with properties:
            Name: "Neuroscience Dataset Example"
     Description: "A tutorial dataset for learning openMINDS metadata creation"
           Nodes: dictionary with unset key and value types
    LinkResolver: []
```
<a name="H_811913EA"></a>
# 2. Creating Basic Metadata Instances

Let's create instances for researchers and their organizations. We'll demonstrate two ways to create instances: 1. Using name-value pairs in the constructor 2. Creating an empty instance and setting properties via dot notation

```matlab
% Define a utility function for creating instance IDs
createId = @(str) lower(sprintf('_:%s', replace(str, ' ', '-')));
```
<a name="H_2B8616D2"></a>
## 2.1 Create organization instances
```matlab
% First approach: Using name-value pairs in the constructor
university = openminds.core.actors.Organization(...
    'id', createId('University of Neuroscience'), ...
    'fullName', 'University of Neuroscience', ...
    'shortName', 'UNS');

% Second approach: Create empty instance and set properties
researchCenter = openminds.core.actors.Organization();
researchCenter.id = createId('Brain Research Center');
researchCenter.fullName = 'Brain Research Center';
researchCenter.shortName = 'BRC';

% Display the Organization metadata instances:
disp(university);
```

```TextOutput
  Organization (https://openminds.om-i.org/types/Organization) with properties:
          affiliation: [None]  (Affiliation)
    digitalIdentifier: [None]  (Any of: GRIDID, RORID, RRID)
             fullName: "University of Neuroscience"
            hasParent: [None]  (Organization)
             homepage: ""
            shortName: "UNS"
  Required Properties: fullName
```

```matlab
disp(researchCenter);
```

```TextOutput
  Organization (https://openminds.om-i.org/types/Organization) with properties:
          affiliation: [None]  (Affiliation)
    digitalIdentifier: [None]  (Any of: GRIDID, RORID, RRID)
             fullName: "Brain Research Center"
            hasParent: [None]  (Organization)
             homepage: ""
            shortName: "BRC"
  Required Properties: fullName
```
<a name="H_326DAA87"></a>
## 2.2 Create contact information instances
```matlab
contactPI = openminds.core.actors.ContactInformation(...
    'id', createId('contact-pi'), ...
    'email', 'pi@neuroscience.edu');

contactPostdoc = openminds.core.actors.ContactInformation(...
    'id', createId('contact-postdoc'), ...
    'email', 'postdoc@neuroscience.edu');

disp(contactPI)
```

```TextOutput
  ContactInformation (https://openminds.om-i.org/types/ContactInformation) with properties:
    email: "pi@neuroscience.edu"
  Required Properties: email
```

```matlab
disp(contactPostdoc)
```

```TextOutput
  ContactInformation (https://openminds.om-i.org/types/ContactInformation) with properties:
    email: "postdoc@neuroscience.edu"
  Required Properties: email
```
<a name="H_83D5A6A9"></a>
## 2.3 Create person instances with affiliations
<a name="H_21D87695"></a>
```matlab
% Principal Investigator
pi = openminds.core.actors.Person(...
    'id', createId('jane-doe'), ...
    'givenName', 'Jane', ...
    'familyName', 'Doe', ...
    'contactInformation', contactPI, ...
    'affiliation', openminds.core.actors.Affiliation('memberOf', university));

% Postdoc
postdoc = openminds.core.actors.Person(...
    'id', createId('john-smith'), ...
    'givenName', 'John', ...
    'familyName', 'Smith', ...
    'contactInformation', contactPostdoc, ...
    'affiliation', openminds.core.actors.Affiliation('memberOf', researchCenter));

% Display the Person metadata instances:
disp(pi) 
```

```TextOutput
  Person (https://openminds.om-i.org/types/Person) with properties:
           affiliation: University of Neuroscience  (Affiliation)
         alternateName: [1x0 string]
     associatedAccount: [None]  (AccountInformation)
    contactInformation: pi@neuroscience.edu  (ContactInformation)
     digitalIdentifier: [None]  (ORCID)
            familyName: "Doe"
             givenName: "Jane"
  Required Properties: givenName
```

```matlab
disp(postdoc)
```

```TextOutput
  Person (https://openminds.om-i.org/types/Person) with properties:
           affiliation: Brain Research Center  (Affiliation)
         alternateName: [1x0 string]
     associatedAccount: [None]  (AccountInformation)
    contactInformation: postdoc@neuroscience.edu  (ContactInformation)
     digitalIdentifier: [None]  (ORCID)
            familyName: "Smith"
             givenName: "John"
  Required Properties: givenName
```
<a name="H_BA8C6418"></a>
# 3. Creating Dataset Metadata

Now we'll create a dataset version to describe our neuroscience data. We'll add all the required properties and some optional ones.

<a name="H_FECC0736"></a>
## 3.1 Create a DOI (Digital Object Identifier)
```matlab
doi = openminds.core.digitalidentifier.DOI(...
    'id', createId('dataset-doi'), ...
    'identifier', 'https://doi.org/10.1234/example.2023.001');
```
<a name="H_D8624084"></a>
## 3.2 Create a license

The **<samp>License</samp>** is one of a few types where pre-defined instances already exist. To view available instances, use the **<samp>listInstances</samp>** method:

```matlab
openminds.core.data.License.listInstances()
```

```TextOutput
ans = 31x1 string    
"AGPL-3.0-only"
"Apache-2.0"   
"BSD-2-Clause" 
"BSD-3-Clause" 
"BSD-4-Clause" 
"CC-BY-4.0"    
"CC-BY-NC-4.0" 
"CC-BY-NC-ND…  
"CC-BY-NC-SA…  
"CC-BY-ND-4.0" 
```

```matlab
% Create a license from a name:
license = openminds.core.data.License.fromName("CC-BY-4.0");
disp(license)
```

```TextOutput
  License (https://openminds.om-i.org/types/License) with properties:
     fullName: "Creative Commons Attribution 4.0 International"
    legalCode: "https://creativecommons.org/licenses/by/4.0/legalcode"
    shortName: "CC-BY-4.0"
      webpage: ["https://creativecommons.org/licenses/by/4.0"    "https://spdx.org/licenses/CC-BY-4.0.html"]
  Required Properties: fullName, legalCode, shortName
```

```matlab
% Alternatively, create it manually
license = openminds.core.data.License(...
    'id', createId('cc-by-4'), ...
    'fullName', 'Creative Commons Attribution 4.0 International', ...
    'shortName', 'CC BY 4.0', ...
    'webpage', "https://creativecommons.org/licenses/by/4.0");
```
<a name="H_8E41DC07"></a>
## 3.3 Create a file repository
<a name="H_20CDEE8F"></a>

Note: This is only relevant if data is stored in external repository. If a dataset is submitted via EBRAINS, the file repository is created and added as part of the curation process

```matlab
repository = openminds.core.data.FileRepository(...
    'id', createId('dataset-repository'), ...
    'IRI', 'https://example-repository.org/datasets/123', ...
    'name', 'Example Dataset Repository', ...
    'hostedBy', university);
```
<a name="H_A9E27051"></a>
## 3.4 Create a behavioral protocol
```matlab
protocol = openminds.core.research.BehavioralProtocol(...
    'id', createId('visual-task-protocol'), ...
    'name', 'Visual Go/NoGo Task', ...
    'description', ['Mice were trained to discriminate visual stimuli. ', ...
    'Each stimulus was associated with a specific outcome (reward, nothing, or punishment).']);
```
<a name="H_31DD0816"></a>
## 3.5 Create controlled terms

Controlled terms are metatata types which has a corresponding terminology developed by the Open Metadata Initiative, available here: [https://github.com/openMetadataInitiative/openMINDS_instances](https://github.com/openMetadataInitiative/openMINDS_instances)


To see a list of available instance, you can again use the **<samp>listInstances</samp>**. 


**Note**: ControlledTerm types accept the instance names as an input to the class constructor directly (See below for examples).

```matlab
openminds.controlledterms.PreparationType.listInstances()
```

```TextOutput
ans = 6x1 string    
"exVivo"    
"inSilico"  
"inSitu"    
"inUtero"   
"inVitro"   
"inVivo"    
```

```matlab
% These are predefined terms from controlled vocabularies
preparationType = openminds.controlledterms.PreparationType('inVivo');

ethicsAssessment = openminds.controlledterms.EthicsAssessment('EUCompliant');

accessibility = openminds.controlledterms.ProductAccessibility('freeAccess');

dataType = openminds.controlledterms.SemanticDataType('experimentalData');

experimentalApproach1 = openminds.controlledterms.ExperimentalApproach('behavior');
experimentalApproach2 = openminds.controlledterms.ExperimentalApproach('electrophysiology');

technique = openminds.controlledterms.Technique('extracellularElectrophysiology');
```
<a name="H_FAF6F121"></a>
## 3.6 Create a custom term suggestion (for keywords that don't exist in controlled vocabularies)
```matlab
customKeyword = openminds.controlledterms.TermSuggestion(...
    'id', createId('custom-brain-region'), ...
    'name', 'visual cortex');
```
<a name="H_D54334A9"></a>
## 3.7 Create the dataset version
```matlab
datasetVersion = openminds.core.products.DatasetVersion(...
    'id', createId('example-dataset-v1'), ...
    'fullName', 'Neural activity during visual discrimination task', ...
    'shortName', 'Visual Task Dataset', ...
    'versionIdentifier', 'v1', ...
    'accessibility', accessibility, ...
    'author', [pi, postdoc], ...
    'custodian', pi, ...
    'description', ['This dataset contains neural recordings from mice ', ...
    'performing a visual discrimination task.'], ...
    'digitalIdentifier', doi, ...
    'ethicsAssessment', ethicsAssessment, ...
    'experimentalApproach', [experimentalApproach1, experimentalApproach2], ...
    'license', license, ...
    'preparationDesign', preparationType, ...
    'repository', repository, ...
    'dataType', dataType, ...
    'technique', technique, ...
    'behavioralProtocol', protocol, ...
    'keyword', customKeyword, ...
    'versionInnovation', 'This is the first version of this dataset.');

disp(datasetVersion);
```

```TextOutput
  DatasetVersion (https://openminds.om-i.org/types/DatasetVersion) with properties:
             accessibility: free access  (ProductAccessibility)
                    author: [Doe, Jane  (Person)    Smith, John  (Person)]  (Any of: Consortium, Organization, Person)
        behavioralProtocol: Visual Go/NoGo Task  (BehavioralProtocol)
                 copyright: [None]  (Copyright)
                 custodian: Doe, Jane  (Any of: Consortium, Organization, Person)
                  dataType: experimental data  (SemanticDataType)
               description: "This dataset contains neural recordings from mice performing a visual discrimination task."
         digitalIdentifier: https://doi.org/10.1234/example.2023.001  (One of: DOI, IdentifiersDotOrgID)
          ethicsAssessment: EU compliant  (EthicsAssessment)
      experimentalApproach: [behavior    electrophysiology]  (ExperimentalApproach)
         fullDocumentation: [None]  (One of: File, DOI, ISBN, WebResource)
                  fullName: "Neural activity during visual discrimination task"
                   funding: [None]  (Funding)
                  homepage: ""
                 howToCite: ""
                 inputData: [None]  (Any of: File, FileBundle, DOI, WebResource, BrainAtlas, BrainAtlasVersion, CommonCoordinateSpace, CommonCoordinateSpaceVersion)
    isAlternativeVersionOf: [None]  (DatasetVersion)
            isNewVersionOf: [None]  (DatasetVersion)
                   keyword: [1x1 Keyword]
                   license: Creative Commons Attribution 4.0 International  (One of: License, WebResource)
         otherContribution: [None]  (Contribution)
         preparationDesign: in vivo  (PreparationType)
                  protocol: [None]  (Protocol)
        relatedPublication: [None]  (Any of: DOI, HANDLE, ISBN, ISSN, Book, Chapter, ScholarlyArticle)
               releaseDate: [1x0 datetime]
                repository: Example Dataset Repository  (FileRepository)
                 shortName: "Visual Task Dataset"
           studiedSpecimen: [None]  (Any of: Subject, SubjectGroup, TissueSample, TissueSampleCollection)
               studyTarget: [1x0 StudyTarget]
            supportChannel: [1x0 string]
                 technique: extracellular electrophysiology  (Any of: AnalysisTechnique, MRIPulseSequence, MRIWeighting, StimulationApproach, StimulationTechnique, Technique)
         versionIdentifier: "v1"
         versionInnovation: "This is the first version of this dataset."
  Required Properties: accessibility, dataType, digitalIdentifier, ethicsAssessment,
    experimentalApproach, fullDocumentation, license, releaseDate, shortName, technique,
    versionIdentifier, versionInnovation
```
<a name="H_FC44336C"></a>
# 4. Creating Subject Metadata

Now we'll create subjects and their states, then link them to the dataset.

<a name="H_FE1CCF54"></a>
## 4.1 Create a species (strain)
```matlab
strain = openminds.core.research.Strain(...
    'id', createId('c57bl6j-strain'), ...
    'name', 'C57BL/6J', ...
    'species', openminds.controlledterms.Species('musMusculus'));
```
<a name="H_DEDF3B40"></a>
## 4.2 Create biological sex controlled term
```matlab
biologicalSex = openminds.controlledterms.BiologicalSex('male');
```
<a name="H_46CDB34E"></a>
## 4.3 Create subject state attributes
```matlab
subjectAttribute1 = openminds.controlledterms.SubjectAttribute('alive');
subjectAttribute2 = openminds.controlledterms.SubjectAttribute('awake');

ageCategory = openminds.controlledterms.AgeCategory('adult');
```
<a name="H_C964FE25"></a>
## 4.4 Create a subject
```matlab
subject1 = openminds.core.research.Subject(...
    'id', createId('subject1'), ...
    'lookupLabel', 'Subject1', ...
    'biologicalSex', biologicalSex, ...
    'species', strain, ...
    'internalIdentifier', 'S1');
```
<a name="H_91A556DE"></a>
## 4.5 Create another subject
```matlab
subject2 = openminds.core.research.Subject(...
    'id', createId('subject2'), ...
    'lookupLabel', 'Subject2', ...
    'biologicalSex', biologicalSex, ...
    'species', strain, ...
    'internalIdentifier', 'S2');
```
<a name="H_48F6094F"></a>
## 4.6 Create and add subject states for each of the subjects
```matlab
subjectState1 = openminds.core.research.SubjectState(...
    'id', createId('subject1-state'), ...
    'lookupLabel', 'Subject1-state', ...
    'ageCategory', ageCategory, ...
    'attribute', [subjectAttribute1, subjectAttribute2], ...
    'internalIdentifier', 'Subject1-state-01');
subject1.studiedState = subjectState1;

subjectState2 = openminds.core.research.SubjectState(...
    'id', createId('subject2-state'), ...
    'lookupLabel', 'Subject2-state', ...
    'ageCategory', "adolescent", ...
    'attribute', [subjectAttribute1, subjectAttribute2], ...
    'internalIdentifier', 'Subject2-state-01');
subject2.studiedState = subjectState2;

% Display the Subject metadata
disp(subject1);
```

```TextOutput
  Subject (https://openminds.om-i.org/types/Subject) with properties:
         biologicalSex: male  (BiologicalSex)
    internalIdentifier: "S1"
              isPartOf: [None]  (SubjectGroup)
           lookupLabel: "Subject1"
               species: C57BL/6J  (One of: Species, Strain)
          studiedState: Subject1-state  (SubjectState)
  Required Properties: species, studiedState
```

```matlab
disp(subject2);
```

```TextOutput
  Subject (https://openminds.om-i.org/types/Subject) with properties:
         biologicalSex: male  (BiologicalSex)
    internalIdentifier: "S2"
              isPartOf: [None]  (SubjectGroup)
           lookupLabel: "Subject2"
               species: C57BL/6J  (One of: Species, Strain)
          studiedState: Subject2-state  (SubjectState)
  Required Properties: species, studiedState
```
<a name="H_75B707F7"></a>
## 4.7 Link subjects to the dataset
```matlab
datasetVersion.studiedSpecimen = [subject1, subject2];

% Display the updated dataset version with added specimen:
disp(datasetVersion);
```

```TextOutput
  DatasetVersion (https://openminds.om-i.org/types/DatasetVersion) with properties:
             accessibility: free access  (ProductAccessibility)
                    author: [Doe, Jane  (Person)    Smith, John  (Person)]  (Any of: Consortium, Organization, Person)
        behavioralProtocol: Visual Go/NoGo Task  (BehavioralProtocol)
                 copyright: [None]  (Copyright)
                 custodian: Doe, Jane  (Any of: Consortium, Organization, Person)
                  dataType: experimental data  (SemanticDataType)
               description: "This dataset contains neural recordings from mice performing a visual discrimination task."
         digitalIdentifier: https://doi.org/10.1234/example.2023.001  (One of: DOI, IdentifiersDotOrgID)
          ethicsAssessment: EU compliant  (EthicsAssessment)
      experimentalApproach: [behavior    electrophysiology]  (ExperimentalApproach)
         fullDocumentation: [None]  (One of: File, DOI, ISBN, WebResource)
                  fullName: "Neural activity during visual discrimination task"
                   funding: [None]  (Funding)
                  homepage: ""
                 howToCite: ""
                 inputData: [None]  (Any of: File, FileBundle, DOI, WebResource, BrainAtlas, BrainAtlasVersion, CommonCoordinateSpace, CommonCoordinateSpaceVersion)
    isAlternativeVersionOf: [None]  (DatasetVersion)
            isNewVersionOf: [None]  (DatasetVersion)
                   keyword: [1x1 Keyword]
                   license: Creative Commons Attribution 4.0 International  (One of: License, WebResource)
         otherContribution: [None]  (Contribution)
         preparationDesign: in vivo  (PreparationType)
                  protocol: [None]  (Protocol)
        relatedPublication: [None]  (Any of: DOI, HANDLE, ISBN, ISSN, Book, Chapter, ScholarlyArticle)
               releaseDate: [1x0 datetime]
                repository: Example Dataset Repository  (FileRepository)
                 shortName: "Visual Task Dataset"
           studiedSpecimen: [Subject1  (Subject)    Subject2  (Subject)]  (Any of: Subject, SubjectGroup, TissueSample, TissueSampleCollection)
               studyTarget: [1x0 StudyTarget]
            supportChannel: [1x0 string]
                 technique: extracellular electrophysiology  (Any of: AnalysisTechnique, MRIPulseSequence, MRIWeighting, StimulationApproach, StimulationTechnique, Technique)
         versionIdentifier: "v1"
         versionInnovation: "This is the first version of this dataset."
  Required Properties: accessibility, dataType, digitalIdentifier, ethicsAssessment,
    experimentalApproach, fullDocumentation, license, releaseDate, shortName, technique,
    versionIdentifier, versionInnovation
```
<a name="H_C34C62C9"></a>
# 5. Adding Instances to Collection and Saving

Now we'll add all instances to the collection and save it to a file.

<a name="H_02873F7B"></a>
## 5.1 Add the dataset to the collection
```matlab
% Note: The collection will automatically include all linked instances
collection.add(datasetVersion);

disp(collection);
```

```TextOutput
  Collection with properties:
            Name: "Neuroscience Dataset Example"
     Description: "A tutorial dataset for learning openMINDS metadata creation"
           Nodes: dictionary (string ⟼ cell) with 30 entries
    LinkResolver: []
```
<a name="H_7C761973"></a>
## 5.2 Save the collection to a JSON-LD file
```matlab
% Define the save path (in the current directory)
savePath = fullfile(pwd, 'example_metadata.jsonld');
collection.save(savePath);

disp(['Saved metadata to: ', savePath]);
```

```TextOutput
Saved metadata to: /Users/Eivind/Code/MATLAB/Neuroscience/Repositories/openMetadataInitiative/openMINDS_MATLAB/code/example_metadata.jsonld
```
<a name="H_65639D51"></a>
## 5.3 Display the saved JSON-LD content
```matlab
jsonContent = fileread(savePath);
disp(jsonContent);
```

```TextOutput
{
  "@context": {
    "@vocab": "https://openminds.ebrains.eu/vocab/"
  },
  "@graph": [
    {
      "@id": "_:example-dataset-v1",
      "@type": "https://openminds.om-i.org/types/DatasetVersion",
      "accessibility": {
        "@id": "https://openminds.om-i.org/instances/productAccessibility/freeAccess"
      },
      "author": [
        {
          "@id": "_:jane-doe"
        },
        {
          "@id": "_:john-smith"
        }
      ],
      "behavioralProtocol": [
        {
          "@id": "_:visual-task-protocol"
        }
      ],
      "custodian": [
        {
          "@id": "_:jane-doe"
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
      "ethicsAssessment": {
        "@id": "https://openminds.om-i.org/instances/ethicsAssessment/EUCompliant"
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
      "keyword": [
        {
          "@id": "_:custom-brain-region"
        }
      ],
      "license": {
        "@id": "_:cc-by-4"
      },
      "preparationDesign": [
        {
          "@id": "https://openminds.om-i.org/instances/preparationType/inVivo"
        }
      ],
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
      "versionIdentifier": "v1",
      "versionInnovation": "This is the first version of this dataset."
    },
    {
      "@id": "https://openminds.om-i.org/instances/productAccessibility/freeAccess",
      "@type": "https://openminds.om-i.org/types/ProductAccessibility",
      "definition": "With ''free access'' selected, data and metadata are both released and become immediately available without any access restrictions.",
      "name": "free access"
    },
    {
      "@id": "_:jane-doe",
      "@type": "https://openminds.om-i.org/types/Person",
      "affiliation": [
        {
          "@type": "https://openminds.om-i.org/types/Affiliation",
          "memberOf": {
            "@id": "_:university-of-neuroscience"
          }
        }
      ],
      "contactInformation": {
        "@id": "_:contact-pi"
      },
      "familyName": "Doe",
      "givenName": "Jane"
    },
    {
      "@id": "_:contact-pi",
      "@type": "https://openminds.om-i.org/types/ContactInformation",
      "email": "pi@neuroscience.edu"
    },
    {
      "@id": "_:university-of-neuroscience",
      "@type": "https://openminds.om-i.org/types/Organization",
      "fullName": "University of Neuroscience",
      "shortName": "UNS"
    },
    {
      "@id": "_:john-smith",
      "@type": "https://openminds.om-i.org/types/Person",
      "affiliation": [
        {
          "@type": "https://openminds.om-i.org/types/Affiliation",
          "memberOf": {
            "@id": "_:brain-research-center"
          }
        }
      ],
      "contactInformation": {
        "@id": "_:contact-postdoc"
      },
      "familyName": "Smith",
      "givenName": "John"
    },
    {
      "@id": "_:contact-postdoc",
      "@type": "https://openminds.om-i.org/types/ContactInformation",
      "email": "postdoc@neuroscience.edu"
    },
    {
      "@id": "_:brain-research-center",
      "@type": "https://openminds.om-i.org/types/Organization",
      "fullName": "Brain Research Center",
      "shortName": "BRC"
    },
    {
      "@id": "_:visual-task-protocol",
      "@type": "https://openminds.om-i.org/types/BehavioralProtocol",
      "description": "Mice were trained to discriminate visual stimuli. Each stimulus was associated with a specific outcome (reward, nothing, or punishment).",
      "name": "Visual Go/NoGo Task"
    },
    {
      "@id": "https://openminds.om-i.org/instances/semanticDataType/experimentalData",
      "@type": "https://openminds.om-i.org/types/SemanticDataType",
      "name": "experimental data"
    },
    {
      "@id": "_:dataset-doi",
      "@type": "https://openminds.om-i.org/types/DOI",
      "identifier": "https://doi.org/10.1234/example.2023.001"
    },
    {
      "@id": "https://openminds.om-i.org/instances/ethicsAssessment/EUCompliant",
      "@type": "https://openminds.om-i.org/types/EthicsAssessment",
      "definition": "Data are ethically approved in compliance with EU law. No additional ethics assessment was made by the data sharing initiative.",
      "description": "Data are ethically approved in compliance with EU law. No additional ethics assessment was made by the data sharing initiative. This is typically true for all, human post-mortem data, human cross-subject statistics, non-primate vertebrate animals as well as cephalopods.",
      "name": "EU compliant"
    },
    {
      "@id": "https://openminds.om-i.org/instances/experimentalApproach/behavior",
      "@type": "https://openminds.om-i.org/types/ExperimentalApproach",
      "definition": "Any experimental approach focused on the mechanical activity or cognitive processes underlying mechanical activity of living organisms often in response to external sensory stimuli.",
      "interlexIdentifier": "http://uri.interlex.org/base/ilx_0739413",
      "name": "behavior",
      "preferredOntologyIdentifier": "http://uri.interlex.org/tgbugs/uris/readable/modality/Behavior",
      "synonym": [
        "behavioral approach"
      ]
    },
    {
      "@id": "https://openminds.om-i.org/instances/experimentalApproach/electrophysiology",
      "@type": "https://openminds.om-i.org/types/ExperimentalApproach",
      "definition": "Any experimental approach focused on electrical phenomena associated with living systems, most notably the nervous system, cardiac system, and musculoskeletal system.",
      "interlexIdentifier": "http://uri.interlex.org/base/ilx_0741202",
      "name": "electrophysiology",
      "preferredOntologyIdentifier": "http://uri.interlex.org/tgbugs/uris/readable/modality/Electrophysiology"
    },
    {
      "@id": "_:custom-brain-region",
      "@type": "https://openminds.om-i.org/types/TermSuggestion",
      "name": "visual cortex"
    },
    {
      "@id": "_:cc-by-4",
      "@type": "https://openminds.om-i.org/types/License",
      "fullName": "Creative Commons Attribution 4.0 International",
      "shortName": "CC BY 4.0",
      "webpage": [
        "https://creativecommons.org/licenses/by/4.0"
      ]
    },
    {
      "@id": "https://openminds.om-i.org/instances/preparationType/inVivo",
      "@type": "https://openminds.om-i.org/types/PreparationType",
      "definition": "Something happening or existing inside a living body.",
      "interlexIdentifier": "http://uri.interlex.org/base/ilx_0739622",
      "name": "in vivo",
      "preferredOntologyIdentifier": "http://uri.interlex.org/tgbugs/uris/indexes/ontologies/methods/89",
      "synonym": [
        "in vivo technique"
      ]
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
      "@id": "https://openminds.om-i.org/instances/biologicalSex/male",
      "@type": "https://openminds.om-i.org/types/BiologicalSex",
      "definition": "Biological sex that produces sperm cells (spermatozoa).",
      "description": "A male organism typically has the capacity to produce relatively small, usually mobile gametes (reproductive cells), called sperm cells (or spermatozoa). In the process of fertilization, these sperm cells fuse with a larger, usually immobile female gamete, called egg cell (or ovum).",
      "interlexIdentifier": "http://uri.interlex.org/base/ilx_0106489",
      "name": "male",
      "preferredOntologyIdentifier": "http://purl.obolibrary.org/obo/PATO_0000384"
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
      "@id": "https://openminds.om-i.org/instances/species/musMusculus",
      "@type": "https://openminds.om-i.org/types/Species",
      "definition": "The species *Mus musculus* (house mouse) belongs to the family of *muridae* (murids).",
      "interlexIdentifier": "http://uri.interlex.org/base/ilx_0107134",
      "knowledgeSpaceLink": "https://knowledge-space.org/wiki/NCBITaxon:10090#mouse",
      "name": "Mus musculus",
      "preferredOntologyIdentifier": "http://purl.obolibrary.org/obo/NCBITaxon_10090",
      "synonym": [
        "house mouse",
        "mouse"
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
      "@id": "https://openminds.om-i.org/instances/ageCategory/adult",
      "@type": "https://openminds.om-i.org/types/AgeCategory",
      "definition": "''Adult'' categorizes the life cycle stage of an animal or human that reached sexual maturity.",
      "interlexIdentifier": "http://uri.interlex.org/base/ilx_0729043",
      "name": "adult",
      "preferredOntologyIdentifier": "http://purl.obolibrary.org/obo/UBERON_0000113",
      "synonym": [
        "adult stage",
        "post-juvenile adult",
        "post-juvenile adult stage"
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
      "@id": "https://openminds.om-i.org/instances/ageCategory/adolescent",
      "@type": "https://openminds.om-i.org/types/AgeCategory",
      "definition": "''Adolescent'' categorizes a transitional life cycle stage of growth and development between childhood and adulthood, often described as ''puberty''.",
      "name": "adolescent",
      "synonym": [
        "puberty"
      ]
    },
    {
      "@id": "https://openminds.om-i.org/instances/technique/extracellularElectrophysiology",
      "@type": "https://openminds.om-i.org/types/Technique",
      "definition": "In ''extracellular electrophysiology'' electrodes are inserted into living tissue, but remain outside the cells in the extracellular environment to measure or stimulate electrical activity coming from adjacent cells, usually neurons.",
      "name": "extracellular electrophysiology"
    }
  ]
}
```
<a name="H_98425D04"></a>
# 6. Summary

In this tutorial, we've learned how to: 

1.  Create a metadata collection
2. Create various metadata instances (people, organizations, etc.)
3. Link instances together
4. Use controlled terms from predefined vocabularies
5. Create custom term suggestions
6. Add instances to a collection
7. Save the collection to a JSON-LD file

This provides a foundation for creating more complex metadata for neuroscience datasets using the openMINDS MATLAB toolbox.

