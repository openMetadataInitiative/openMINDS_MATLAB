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
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Initializing openMINDS_MATLAB...
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
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Added classes for version "
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
latest
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
" of the openMINDS metadata model to the search path.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
```

# Describe a subject

Every openMINDS type is a MATLAB class, and its properties are validated against the schema as you assign them. Here is an adult female mouse. The species and sex are controlled terms and can be given by name.

```matlab
import openminds.core.*
mouse = Subject( ...
    'lookupLabel', 'mouse_01', ...
    'species', 'musMusculus', ...
    'biologicalSex', 'female');
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
disp(mouse)
```

```matlabTextOutput
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
  Subject (_:1) with properties:
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
female (BiologicalSex)
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
: ""
              isPartOf: [None] (SubjectGroup)
           lookupLabel: "mouse_01"
               species: Mus musculus (Species)
          
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
studiedState
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
: 
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
[None] (SubjectState)
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
  Required Properties: species, studiedState
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
```

# Describe the subject at the time of recording

Age and weight belong to a subject state rather than to the subject, because they change. Each is a quantity with a unit, and an age also says what it is counted from.

```matlab
age = SpecimenAge( ...
    'age', QuantitativeValue('value', 12, 'unit', 'week'), ...
    'reference', 'birth');
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
weight = SpecimenWeight( ...
    'weight', QuantitativeValue('value', 24, 'unit', 'gram'), ...
    'type', 'bodyWeight');
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
recordingState = SubjectState( ...
    'lookupLabel', 'mouse_01_recording', ...
    'ageCategory', 'adult', ...
    'age', age, ...
    'weight', weight);
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
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
```

```matlab
disp(recordingState)
```

```matlabTextOutput
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
  SubjectState (_:2) with properties:
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
         
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
additionalRemarks
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
: 
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
""
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
                       
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
age: 12 weeks (birth) (SpecimenAge)
               ageCategory: adult (AgeCategory)
        
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
associatedProtocol
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
: 
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
[1x0 AssociatedProtocol]
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
                 
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
attribute
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
: 
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
[None] (SubjectAttribute)
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
             descendedFrom: [None] (SubjectState)
                handedness: [None] (Handedness)
        internalIdentifier: ""
               lookupLabel: "mouse_01_recording"
                 pathology: [1x0 Pathology]
    
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
relativeTimeIndication
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
: 
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
[1x0 RelativeTimeIndication]
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
                    
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
weight
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
: 
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
24 grams (body weight) (SpecimenWeight)
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
  Required Properties: ageCategory
```

# Link the state to the subject

Assigning an instance to a property links the two. A linked property can hold several instances, so a subject can have a state per session.

```matlab
mouse.studiedState = recordingState;
```

```matlabTextOutput
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
```

```matlab
disp(mouse)
```

```matlabTextOutput
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
  Subject (_:1) with properties:

         biologicalSex: female (BiologicalSex)
    internalIdentifier: ""
              
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
isPartOf
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
: 
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
[None] (SubjectGroup)
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
           
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
lookupLabel
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
: 
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
"mouse_01"
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
               species: Mus musculus (Species)
          studiedState: mouse_01_recording (SubjectState)

  Required Properties: species, studiedState
```

# Save the metadata as JSON-LD

A collection holds a set of instances and writes them as JSON-LD documents. Adding the mouse brings everything it links to along with it.

```matlab
collection = openminds.Collection(mouse);
```

```matlabTextOutput
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
```

```matlab
jsonldFile = fullfile(tempdir, "mouse_01.jsonld");
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
collection.save(jsonldFile);
```

```matlabTextOutput
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
```

# Load it back

Loading from the file rebuilds the instances and the links between them.

```matlab
loaded = openminds.Collection(jsonldFile);
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
fprintf("Loaded %d instances\n", numel(loaded.getAll()))
```

```matlabTextOutput
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Loaded 
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
9
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
 instances
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
Warning: Unable to locate a personal folder for $documents/MATLAB.
Warning: Unable to locate a personal folder for $documents/MATLAB.
```