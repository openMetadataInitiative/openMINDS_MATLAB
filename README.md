# openMINDS Pipeline

This branch contains the openMINDS pipeline for the openMINDS_MATLAB repository. The pipeline ensures that the MATLAB schema classes are up to date with the latest openMINDS schemas.

This pipeline consists of the following workflows:
- `build` : Build the MATLAB schema classes from openMINDS source schemas when these are updated.


## Getting started

```bash
pip install -r requirements.txt
```

python build.py

## Build output

`build.py` clones the openMINDS schemas and instances into `_sources/`, then writes every generated class to `target/`:

```
target/
└── <model version>/
    ├── types/
    │   ├── +openminds/…                       one class per metadata type
    │   └── resources/                         schema manifest and class aliases
    ├── mixedtypes/    +openminds/…            wrappers for properties that accept several types
    └── enumerations/  +openminds/+enum/…      the model's types and modules as enumerations
```

The model version comes first because a version is the unit the toolbox selects: all of its folders are added to and removed from the MATLAB search path together. This mirrors `code/generated/resources` in the toolbox, so applying a build is a single copy.

Each version also gets `types/+openminds/+controlledterms/ControlledTerm.m`, an abstract class holding the properties its controlled terms share. That set differs between model versions, which is why the class is generated per version rather than maintained by hand. The concrete controlled terms extend it, and it extends `openminds.base.ControlledTerm`, the hand-written class in the toolbox that holds the behaviour common to every version.

## Applying a build

```bash
./scripts/apply-new-build.sh <toolbox root>
```

This replaces `code/generated/resources/` in a toolbox checkout with the contents of `target/`, then restores the hand-written readme and contents files that live among the generated classes. Every model version is replaced, so a version the model has dropped does not linger in the toolbox.

## Tests

```bash
python -m unittest discover -s tests
```
