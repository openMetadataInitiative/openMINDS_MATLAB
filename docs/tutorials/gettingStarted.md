
## Before you start
```matlab
% Verify that openMINDS_MATLAB is installed
disp( openminds.toolboxversion )
```

```TextOutput
Version 0.9.1
```

If you have installed **openMINDS_MATLAB** and the above command does not work, most likely **openMINDS_MATLAB** is <u>not</u> added to MATLAB's [search path](https://se.mathworks.com/help/matlab/matlab_env/what-is-the-matlab-search-path.html).

See also: [Crew Member Collection Tutorial](./crewMemberCollection.md)

## Configure MATLAB's path to use the latest model versions
```matlab
% Schema classes for all the openMINDS model versions are available in this
% toolbox. To ensure the latest version is used, run the following command:
selectOpenMindsVersion("latest")
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
