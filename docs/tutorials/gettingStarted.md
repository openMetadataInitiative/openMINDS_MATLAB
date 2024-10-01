
## Before you start
```matlab
% Verify that openMINDS_MATLAB is installed
disp( openminds.toolboxversion )
```

```TextOutput
Version 0.9.3
```

If you have installed **openMINDS_MATLAB** and the above command does not work, most likely **openMINDS_MATLAB** is <u>not</u> added to MATLAB's [search path](https://se.mathworks.com/help/matlab/matlab_env/what-is-the-matlab-search-path.html).


If you opened this file in MATLAB Online from the GitHub Demo link, the following steps should add **openMINDS_MATLAB** to the search path:


1) Open the <samp>code</samp> folder from the <samp>Files</samp> panel on the left sidebar.


2) Open and run the <samp>startup.m</samp> file. Select "Add to Path" if prompted from a popup dialog.


See also: [Crew Member Collection Tutorial](./livescripts/crewMemberCollection.mlx)

## Configure MATLAB's search path to use the latest model versions

Note: The following is only relevant if you have cloned or downloaded openMINDS_MATLAB from GitHub. If you installed the Matlab toolbox, you can skip this part.


The openMINDS_MATLAB toolbox comes packaged with schema classes for all versions of the openMINDS models. Therefore is important to use the [<samp>openminds.startup</samp>](+openminds/startup.m) function to ensure that the search path only contains schema classes for a specific openMINDS version. Provide the version number as an input, i.e "latest", or "v2.0"

```matlab
openminds.startup("latest") % Add schema classes for the latest version to the search path
```

```TextOutput
Initializing openMINDS_MATLAB...
Added schemas for version "latest" to path
```
## Import schemas from the core model
```matlab
import openminds.core.*
```
## Create a Subject
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
## Create a Subject State
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
