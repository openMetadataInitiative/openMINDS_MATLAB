# Before you start

Check that openMINDS\_MATLAB is installed and on the search path.

```matlab
disp( openminds.toolboxversion )
```

```matlabTextOutput
Version 0.10.0
```

# Choose a version of the metadata model

The toolbox ships the types of every version of the openMINDS metadata model, and only one version can be on the search path at a time. If you installed the toolbox, the latest version is already selected and you can skip this. If you cloned the repository, select one:

```matlab
openminds.startup("latest")
```

```matlabTextOutput
Initializing openMINDS_MATLAB...
Added classes for version "latest" of the openMINDS metadata model to the search path.
```

# Describe a subject

Every openMINDS type is a MATLAB class, and its properties are validated against the schema as you assign them. Here is an adult female mouse. The species and sex are controlled terms and can be given by name.

```matlab
import openminds.core.*
mouse = Subject( ...
    'lookupLabel', 'mouse_01', ...
    'species', 'musMusculus', ...
    'biologicalSex', 'female');
disp(mouse)
```

```matlabTextOutput
  Subject (_:1) with properties:


         biologicalSex: female (BiologicalSex)
    internalIdentifier: ""
              isPartOf: [None] (SubjectGroup)
           lookupLabel: "mouse_01"
               species: Mus musculus (Species)
          studiedState: [None] (SubjectState)


  Required Properties: species, studiedState
```

# Describe the subject at the time of recording

Age and weight belong to a subject state rather than to the subject, because they change. Each is a quantity with a unit, and an age also says what it is counted from.

```matlab
age = SpecimenAge( ...
    'age', QuantitativeValue('value', 12, 'unit', 'week'), ...
    'reference', 'birth');
weight = SpecimenWeight( ...
    'weight', QuantitativeValue('value', 24, 'unit', 'gram'), ...
    'type', 'bodyWeight');
recordingState = SubjectState( ...
    'lookupLabel', 'mouse_01_recording', ...
    'ageCategory', 'adult', ...
    'age', age, ...
    'weight', weight);
disp(recordingState)
```

```matlabTextOutput
  SubjectState (_:2) with properties:


         additionalRemarks: ""
                       age: 12 weeks (birth) (SpecimenAge)
               ageCategory: adult (AgeCategory)
        associatedProtocol: [None] (Any of: BehavioralProtocol, Protocol)
                 attribute: [None] (SubjectAttribute)
             descendedFrom: [None] (SubjectState)
                handedness: [None] (Handedness)
        internalIdentifier: ""
               lookupLabel: "mouse_01_recording"
                 pathology: [None] (Any of: Disease, DiseaseModel)
    relativeTimeIndication: [None] (One of: QuantitativeValue, QuantitativeValueRange)
                    weight: 24 grams (body weight) (SpecimenWeight)


  Required Properties: ageCategory
```

# Link the state to the subject

Assigning an instance to a property links the two. A linked property can hold several instances, so a subject can have a state per session.

```matlab
mouse.studiedState = recordingState;
disp(mouse)
```

```matlabTextOutput
  Subject (_:1) with properties:


         biologicalSex: female (BiologicalSex)
    internalIdentifier: ""
              isPartOf: [None] (SubjectGroup)
           lookupLabel: "mouse_01"
               species: Mus musculus (Species)
          studiedState: mouse_01_recording (SubjectState)


  Required Properties: species, studiedState
```

# Save the metadata as JSON\-LD

A collection holds a set of instances and writes them as JSON\-LD documents. Adding the mouse brings everything it links to along with it.

```matlab
collection = openminds.Collection(mouse);
jsonldFile = fullfile(tempdir, "mouse_01.jsonld");
collection.save(jsonldFile);
```

# Load it back

Loading from the file rebuilds the instances and the links between them.

```matlab
loaded = openminds.Collection(jsonldFile);
fprintf("Loaded %d instances\n", numel(loaded.getAll()))
```

```matlabTextOutput
Loaded 9 instances
```