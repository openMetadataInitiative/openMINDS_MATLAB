<a href="/img/light_openMINDS-MATLAB-logo.png">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="/img/dark_openMINDS-MATLAB-logo.png">
    <source media="(prefers-color-scheme: light)" srcset="/img/light_openMINDS-MATLAB-logo.png">
    <img alt="openMINDS MATLAB logo" src="/img/light_openMINDS-MATLAB-logo.png" title="openMINDS MATLAB" align="right" height="70">
  </picture>
</a>

# openMINDS Metadata Models for MATLAB
[![Open in MATLAB Online](https://www.mathworks.com/images/responsive/global/open-in-matlab-online.svg)](https://matlab.mathworks.com/open/github/v1?repo=openMetadataInitiative/openMINDS_MATLAB&file=code/gettingStarted.mlx) [![View openMINDS_MATLAB on File Exchange](https://www.mathworks.com/matlabcentral/images/matlab-file-exchange.svg)](https://se.mathworks.com/matlabcentral/fileexchange/134212-openminds_matlab)


MATLAB package for the openMINDS metadata framework for linked data in neuroscience. The package contains all the latest openMINDS schemas as MATLAB classes in addition to schema base classes and utility methods.

To generally learn more about the openMINDS metadata framework please go to :arrow_right: [**ReadTheDocs**](https://openminds-documentation.readthedocs.io).  
You can test and learn how to use openMINDS in MATLAB by going through a small :arrow_right: [**DEMO**](https://matlab.mathworks.com/open/github/v1?repo=openMetadataInitiative/openMINDS_MATLAB&file=code/gettingStarted.mlx) on MATLAB Online.  

MathWorks provides a free basic version of [MATLAB Online](https://uk.mathworks.com/products/matlab-online.html), but you need to register for a [MathWorks Account](https://www.mathworks.com/mwaccount/register?uri=https%3A%2F%2Fwww.mathworks.com%2Fproducts%2Fmatlab.html).


## Installation

openMINDS for MATLAB can be installed from MATLAB's [Add-On Explorer](https://se.mathworks.com/help/matlab/matlab_env/get-add-ons.html) (recommended). It is also possible to download the MATLAB toolbox from FileExchange or from the Releases page of this repository and install it manually. If you are new to MATLAB, see the detailed [installation instructions](#Detailed-Installation-Instructions)


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

See also: [Crew Member Collection Tutorial](./docs/tutorials/crewMemberCollection.md)

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

## Detailed Installation Instructions
The easiest way to install the openMINDS for MATLAB is to use the [**Add-on Explorer**](https://www.mathworks.com/products/matlab/add-on-explorer.html):
1. Launch the Add-on Explorer from MATLAB's Home tab. Click Add-Ons -> Get Add-Ons<img width="860" alt="openminds_installation_step1" src="https://github.com/openMetadataInitiative/openMINDS_MATLAB/assets/17237719/71e7d8a3-1548-44e4-8ad2-84798773ce90">
2. Search for "openminds"
3. Select openMINDS Metadata Models for MATLAB<img width="860" alt="openminds_installation_step2" src="https://github.com/openMetadataInitiative/openMINDS_MATLAB/assets/17237719/f46eb742-b2c8-47a1-a46b-c96a3d4c0b35">
4. Press the "Add" button.<img width="860" alt="openminds_installation_step4" src="https://github.com/openMetadataInitiative/openMINDS_MATLAB/assets/17237719/cc2edc9e-4a5d-43cd-a3fc-a94a52d8d84a">

## Acknowledgements

<div><img src="https://www.braincouncil.eu/wp-content/uploads/2018/11/wsi-imageoptim-EU-Logo.jpg" alt="EU Logo" height="23%" width="15%" align="right" style="margin-left: 10px"></div>

This open source software code was developed in part or in whole in the Human Brain Project, funded from the European Union's Horizon 2020 Framework Programme for Research and Innovation under Specific Grant Agreements No. 945539 (Human Brain Project SGA3).
