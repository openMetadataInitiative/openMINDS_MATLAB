<a href="/img/light_openMINDS-MATLAB-logo.png">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="/img/dark_openMINDS-MATLAB-logo.png">
    <source media="(prefers-color-scheme: light)" srcset="/img/light_openMINDS-MATLAB-logo.png">
    <img alt="openMINDS-MATLAB-logo" src="/img/light_openMINDS-MATLAB-logo.png" title="openMINDS-MATLAB" align="right" height="70" width="141px"​>
  </picture>
</a>

# openMINDS Metadata Models for MATLAB
[![Version Number](https://img.shields.io/github/v/release/openMetadataInitiative/openMINDS_MATLAB?label=version)](https://github.com/openMetadataInitiative/openMINDS_MATLAB/releases/latest)
[![Open in MATLAB Online](https://github.com/openMetadataInitiative/openMINDS_MATLAB/blob/gh-badges/.github/badges/open-in-matlab-online.svg)](https://matlab.mathworks.com/open/fileexchange/v1?id=134212)
[![View openMINDS_MATLAB on File Exchange](https://github.com/openMetadataInitiative/openMINDS_MATLAB/blob/gh-badges/.github/badges/matlab-file-exchange.svg)](https://se.mathworks.com/matlabcentral/fileexchange/134212-openminds_matlab)
[![MATLAB Tests](.github/badges/tests.svg)](https://github.com/openMetadataInitiative/openMINDS_MATLAB/actions/workflows/run_tests.yml)
[![codecov](https://codecov.io/gh/openMetadataInitiative/openMINDS_MATLAB/graph/badge.svg?token=FTD5FHZSFA)](https://codecov.io/gh/openMetadataInitiative/openMINDS_MATLAB)
[![MATLAB Code Issues](.github/badges/code_issues.svg)](https://github.com/openMetadataInitiative/openMINDS_MATLAB/security/code-scanning)

<p align="center">
  <a href="#installation">Installation</a> •
  <a href="#getting-started">Getting Started</a> •
  <a href="#tutorials">Tutorials</a> •
  <a href="#extending-the-toolbox">Extending</a> •
  <a href="#upgrading">Upgrading</a> •
  <a href="#acknowledgements">Acknowledgements</a>
</p>

---

A MATLAB toolbox for creating [openMINDS](https://openminds-documentation.readthedocs.io) metadata: typed classes for every openMINDS metadata type, linked into a graph, and read from or written to JSON-LD.

Every openMINDS type is a MATLAB class. Properties are validated against the schema as you assign them, links between instances are real object references, and a collection of instances serializes to JSON-LD documents that any openMINDS tool can read. Every version of the metadata model ships in the toolbox; you choose which one is active.

Try it without installing anything: open the [getting-started live script](https://matlab.mathworks.com/open/github/v1?repo=openMetadataInitiative/openMINDS_MATLAB&file=code/gettingStarted.mlx) in MATLAB Online.

## Installation

Requires **MATLAB R2022a** or later.

**From the Add-On Explorer** (recommended) — in MATLAB, open *Home → Add-Ons → Get Add-Ons*, search for `openminds`, and add *openMINDS Metadata Models for MATLAB*. Step-by-step screenshots are [below](#detailed-installation-instructions).

**From a release** — download the `.mltbx` from the [latest release](https://github.com/openMetadataInitiative/openMINDS_MATLAB/releases/latest) or [File Exchange](https://se.mathworks.com/matlabcentral/fileexchange/134212-openminds_matlab) and open it in MATLAB.

**From source** — clone and run the setup script, which adds the toolbox to your path and saves it:

```matlab
!git clone https://github.com/openMetadataInitiative/openMINDS_MATLAB
run(fullfile("openMINDS_MATLAB", "code", "setup.m"))
```

Check the installation with `openminds.toolboxversion`.

## Getting Started

<!-- The section between the markers is generated from code/gettingStarted.mlx by
     the "Export live scripts" workflow. Edit the live script, not this text. -->
<!-- livescript:start -->
### Before you start

Check that openMINDS\_MATLAB is installed and on the search path.

```matlab
disp( openminds.toolboxversion )
```

```matlabTextOutput
Version 0.12.0
```

### Choose a version of the metadata model

The toolbox ships the types of every version of the openMINDS metadata model, and only one version can be on the search path at a time. If you installed the toolbox, the latest version is already selected and you can skip this. If you cloned the repository, select one:

```matlab
openminds.startup("latest")
```

```matlabTextOutput
Initializing openMINDS_MATLAB...
Added classes for version "latest" of the openMINDS metadata model to the search path.
```

### Describe a subject

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

### Describe the subject at the time of recording

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

### Link the state to the subject

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

### Save the metadata as JSON\-LD

A collection holds a set of instances and writes them as JSON\-LD documents. Adding the mouse brings everything it links to along with it.

```matlab
collection = openminds.Collection(mouse);
jsonldFile = fullfile(tempdir, "mouse_01.jsonld");
collection.save(jsonldFile);
```

### Load it back

Loading from the file rebuilds the instances and the links between them.

```matlab
loaded = openminds.Collection(jsonldFile);
fprintf("Loaded %d instances\n", numel(loaded.getAll()))
```

```matlabTextOutput
Loaded 9 instances
```
<!-- livescript:end -->

## Tutorials

Longer worked examples, exported from the live scripts in `code/livescripts`:

- [Crew member collection](docs/tutorials/crewMemberCollection.md) — build a small linked collection from a table, save it, and load it back.
- [Basic neuroscience dataset](docs/tutorials/basicNeuroscienceDataset.md) — describe a dataset, its subjects and their states the way a data repository expects.

Each is also available to run directly in MATLAB Online from the links inside.

## Extending the toolbox

Two extension points are public and stable:

- **Link resolvers.** Implement `openminds.interface.LinkResolver` and register it with `openminds.registerLinkResolver` to resolve references to instances that live somewhere else — a knowledge graph, a local store, an archive.
- **Metadata stores.** Implement `openminds.interface.MetadataStore` to read and write collections to a backend of your own.

To ask what a type looks like — which properties are links, which are embedded, which accept several types — use `openminds.introspection`. It is what the toolbox's own serializers use.

Names under `openminds.internal` are implementation details and may change between releases.

## Upgrading

Releases before 1.0.0 may rename public names. Each release with renames ships a migration guide under [`docs/migration`](docs/migration), listing every old name and its replacement; the guide is linked from the release notes.

## Detailed Installation Instructions
[(Back to top)](#openminds-metadata-models-for-matlab)

The easiest way to install the openMINDS for MATLAB is to use the [**Add-on Explorer**](https://www.mathworks.com/products/matlab/add-on-explorer.html):
1. Launch the Add-on Explorer from MATLAB's Home tab. Click Add-Ons -> Get Add-Ons<img width="860" alt="openminds_installation_step1" src="https://github.com/openMetadataInitiative/openMINDS_MATLAB/assets/17237719/71e7d8a3-1548-44e4-8ad2-84798773ce90">
2. Search for "openminds"
3. Select openMINDS Metadata Models for MATLAB<img width="860" alt="openminds_installation_step2" src="https://github.com/openMetadataInitiative/openMINDS_MATLAB/assets/17237719/f46eb742-b2c8-47a1-a46b-c96a3d4c0b35">
4. Press the "Add" button.<img width="860" alt="openminds_installation_step4" src="https://github.com/openMetadataInitiative/openMINDS_MATLAB/assets/17237719/cc2edc9e-4a5d-43cd-a3fc-a94a52d8d84a">

## Acknowledgements
[(Back to top)](#openminds-metadata-models-for-matlab)

<div><img src="https://www.braincouncil.eu/wp-content/uploads/2018/11/wsi-imageoptim-EU-Logo.jpg" alt="EU Logo" height="23%" width="15%" align="right" style="margin-left: 10px"></div>

This open source software code was developed in part or in whole in the Human Brain Project, funded from the European Union's Horizon 2020 Framework Programme for Research and Innovation under Specific Grant Agreements No. 945539 (Human Brain Project SGA3).
