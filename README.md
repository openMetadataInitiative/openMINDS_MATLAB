<a href="/img/light_openMINDS-MATLAB-logo.png">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="/img/dark_openMINDS-MATLAB-logo.png">
    <source media="(prefers-color-scheme: light)" srcset="/img/light_openMINDS-MATLAB-logo.png">
    <img alt="openMINDS MATLAB logo" src="/img/light_openMINDS-MATLAB-logo.png" title="openMINDS MATLAB" align="right" height="70">
  </picture>
</a>

# openMINDS Metadata Models for MATLAB
[![View openMINDS_MATLAB on File Exchange](https://www.mathworks.com/matlabcentral/images/matlab-file-exchange.svg)](https://se.mathworks.com/matlabcentral/fileexchange/134212-openminds_matlab)


MATLAB package for the openMINDS metadata framework for linked data in neuroscience. The package contains all the latest openMINDS schemas as MATLAB classes in addition to schema base classes and utility methods.

To generally learn more about the openMINDS metadata framework please go to :arrow_right: [**ReadTheDocs**](https://openminds-documentation.readthedocs.io).  
You can test and learn how to use openMINDS in MATLAB by going through a small :arrow_right: [**DEMO**](https://matlab.mathworks.com/open/github/v1?repo=openMetadataInitiative/openMINDS_MATLAB&file=code/gettingStarted.mlx) on MATLAB Online.  

MathWorks provides a free basic version of [MATLAB Online](https://uk.mathworks.com/products/matlab-online.html), but you need to register a [MathWorks Account](https://www.mathworks.com/mwaccount/register?uri=https%3A%2F%2Fwww.mathworks.com%2Fproducts%2Fmatlab.html).


## Installation

openMINDS for MATLAB can be installed from MATLAB's addon manager (recommended). It is also possible to download the MATLAB toolbox from FileExchange or from the Releases page of this repository and install it manually. 


## Before you start
```matlab
% Verify that openMINDS_MATLAB is installed
disp( openminds.toolboxversion )
```

```TextOutput
Version 0.9.1
```

If you have installed **openMINDS_MATLAB** and the above command does not work, most likely **openMINDS_MATLAB** is <u>not</u> added to MATLAB's [search path](https://se.mathworks.com/help/matlab/matlab_env/what-is-the-matlab-search-path.html).


## Getting Started

See also: [Crew Member Collection Tutorial](./crewMemberCollection.md)

### Configure MATLAB's path to use the latest model versions
```matlab
% Schema classes for all the openMINDS model versions are available in this
% toolbox. To ensure the latest version is used, run the following command:
selectOpenMindsVersion("latest")
```
### Import schemas from the core model
```matlab
import openminds.core.*
```
### Create a Subject
```matlab
% Create a new demo subject
subject1 = Subject('species', 'musMusculus', 'biologicalSex', 'male', 'lookupLabel', 'demo_subject1');
disp(subject1)
```

```TextOutput
  Subject (https://openminds.ebrains.eu/core/Subject) with properties:
         biologicalSex: male  (BiologicalSex)
    internalIdentifier: ""
              isPartOf: [None]  (SubjectGroup)
           lookupLabel: "demo_subject1"
               species: Mus musculus  (One of: Species, Strain)
          studiedState: [None]  (SubjectState)
  Required Properties: species, studiedState
```
### Create a Subject State
```matlab
subjectState = openminds.core.SubjectState('lookupLabel', 'demo_state')
```

```TextOutput
subjectState = 
  SubjectState (https://openminds.ebrains.eu/core/SubjectState) with properties:
         additionalRemarks: ""
                       age: [None]  (One of: QuantitativeValue, QuantitativeValueRange)
               ageCategory: [None]  (AgeCategory)
                 attribute: [None]  (SubjectAttribute)
             descendedFrom: [None]  (SubjectState)
                handedness: [None]  (Handedness)
        internalIdentifier: ""
               lookupLabel: "demo_state"
                 pathology: [None]  (Any of: Disease, DiseaseModel)
    relativeTimeIndication: [None]  (One of: QuantitativeValue, QuantitativeValueRange)
                    weight: [None]  (One of: QuantitativeValue, QuantitativeValueRange)
  Required Properties: ageCategory
```

```matlab
% Add subject state to subject
subject1.studiedState = subjectState;
disp(subject1)
```

```TextOutput
  Subject (https://openminds.ebrains.eu/core/Subject) with properties:
         biologicalSex: male  (BiologicalSex)
    internalIdentifier: ""
              isPartOf: [None]  (SubjectGroup)
           lookupLabel: "demo_subject1"
               species: Mus musculus  (One of: Species, Strain)
          studiedState: demo_state  (SubjectState)
  Required Properties: species, studiedState
```

```matlab
% Update the value of the lookup label
subjectState.lookupLabel = "demo_subjectstate_pre_recording";

% Create a new subject state
subjectStatePost = openminds.core.SubjectState('lookupLabel', 'demo_subjectstate_post_recording')
```

```TextOutput
subjectStatePost = 
  SubjectState (https://openminds.ebrains.eu/core/SubjectState) with properties:
         additionalRemarks: ""
                       age: [None]  (One of: QuantitativeValue, QuantitativeValueRange)
               ageCategory: [None]  (AgeCategory)
                 attribute: [None]  (SubjectAttribute)
             descendedFrom: [None]  (SubjectState)
                handedness: [None]  (Handedness)
        internalIdentifier: ""
               lookupLabel: "demo_subjectstate_post_recording"
                 pathology: [None]  (Any of: Disease, DiseaseModel)
    relativeTimeIndication: [None]  (One of: QuantitativeValue, QuantitativeValueRange)
                    weight: [None]  (One of: QuantitativeValue, QuantitativeValueRange)
  Required Properties: ageCategory
```

```matlab
% Append the new subject state to the subject's studiedState property
subject1.studiedState(end+1) = subjectStatePost;
disp(subject1)
```

```TextOutput
  Subject (https://openminds.ebrains.eu/core/Subject) with properties:
         biologicalSex: male  (BiologicalSex)
    internalIdentifier: ""
              isPartOf: [None]  (SubjectGroup)
           lookupLabel: "demo_subject1"
               species: Mus musculus  (One of: Species, Strain)
          studiedState: [demo_subjectstate_pre_recording    demo_subjectstate_post_recording]  (SubjectState)
  Required Properties: species, studiedState
```
