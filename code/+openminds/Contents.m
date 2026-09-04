% openMINDS
%   Create, link and serialize openMINDS compliant metadata in MATLAB.
%
%   Metadata types for each version of the openMINDS metadata model are
%   generated into separate packages. Use selectModelVersion to place one
%   version on the search path.
%
% Types and collections
%   Node                    - Base class for every openMINDS metadata type
%   Collection              - Container for a linked graph of metadata nodes
%   fromTypeName            - Create a blank instance from a type name or IRI
%   instanceFromIRI         - Retrieve a controlled term instance from its IRI
%
% Model version
%   selectModelVersion      - Put one version of the metadata model on the path
%   getModelVersion         - Return the model version currently on the path
%   version                 - Get or set the active model version
%
% Toolbox
%   startup                 - Configure the search path for this toolbox
%   toolboxdir              - Absolute path to the toolbox code folder
%   toolboxversion          - Version of the installed toolbox
%   getpref                 - Read a toolbox preference
%   setpref                 - Write a toolbox preference
%
% Extension points
%   registerLinkResolver    - Register a resolver for external instance links
%
% Argument validation
%   mustBeOpenMINDSIRI      - Validate that a value is an openMINDS IRI
%   mustBeValidModelVersion - Validate that a value names a model version
%
% Type introspection
%   meta.Type               - Describes the properties of a metadata type
%   meta.fromInstance       - Describe the type of an instance, cached
%   meta.fromClassName      - Describe a type by name, cached
%
% Packages
%   base                    - Base classes the generated types are built on
%   interface               - Contracts implemented by toolbox extensions
%   utility                 - Helper functions for working with instances
%   constant                - Constants of the openMINDS metadata model
%   internal                - Implementation details; not part of the public API
