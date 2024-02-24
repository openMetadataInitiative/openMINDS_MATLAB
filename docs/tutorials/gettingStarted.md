
## Configure MATLAB's path to use the latest model versions

Note: Make sure **MATLAB_openMINDS** has been added to MATLAB's [search path](https://se.mathworks.com/help/matlab/matlab_env/what-is-the-matlab-search-path.html). If you installed **MATLAB_openMINDS** using the AddonManager, this should already have been taken care of.

```matlab
selectOpenMindsVersion("latest")
```
## Import schemas from core model
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
subjectState.lookupLabel = "demo_subjectstate_pre_recording";

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
subject1.studiedState(end+1) = subjectStatePost
```

```TextOutput
subject1 = 
  Subject (https://openminds.ebrains.eu/core/Subject) with properties:
         biologicalSex: male  (BiologicalSex)
    internalIdentifier: ""
              isPartOf: [None]  (SubjectGroup)
           lookupLabel: "demo_subject1"
               species: Mus musculus  (One of: Species, Strain)
          studiedState: [demo_subjectstate_pre_recording    demo_subjectstate_post_recording]  (SubjectState)
  Required Properties: species, studiedState
```

```matlab
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
