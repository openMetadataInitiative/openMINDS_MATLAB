# Generated code

Everything below this folder is written by the openMINDS MATLAB pipeline from
the openMINDS schemas. Do not edit it by hand: the next build overwrites it.
Change the pipeline instead.

## Layout

```
generated/
└── resources/
    └── <model version>/
        ├── types/         +openminds/…            classes for the metadata types
        ├── mixedtypes/    +openminds/…            wrappers for properties that accept several types
        ├── enumerations/  +openminds/+enum/…      the model's types and modules as enumerations
        └── base/          +openminds/+base/…      the controlled term base class of this version
```

The model version comes first, because a version is the unit you select. All
four folders of one version belong together, and folders of different versions
are never on the path at the same time.

## Why "resources"

MATLAB's `genpath` skips folders named `resources`, so
`addpath(genpath(...))` over this toolbox cannot pull every model version onto
the path at once. Classes of different versions share names, so having two
versions on the path shadows one with the other.

Selecting a version is therefore deliberate, and `openminds.startup` and
`openminds.selectModelVersion` are the supported ways to do it:

```matlab
openminds.startup("v4.0")
```

They add the four folders of the requested version and remove any other
version's, so exactly one model version is ever reachable.
