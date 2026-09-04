# Public API surface

What this toolbox promises to keep stable, and what it reserves the right to
change. Written ahead of v1.0.0, when those promises start binding.

## The rule

**A name is public if and only if it is reachable under `openminds.` without
passing through `openminds.internal.`**

There is one exception, called out because it cannot be expressed in a package
name: the unpackaged property validators in `code/validators` are public,
because generated type classes reference them unqualified in `arguments` blocks
and user-facing validation errors name them.

Folder layout follows the rule rather than defining it. Everything ships from
`code/+openminds`, so the package path is the only boundary a reader has to
learn.

## Stability promise from v1.0.0

For public names, within a major version:

- A name is not removed or renamed without a deprecation shim that warns once
  per session and keeps working for at least one minor release.
- A function does not lose an input or output, and does not change the meaning
  of one.
- A class does not remove or rename a public property, method, or event.
- Additive change is always allowed: new functions, new optional name-value
  arguments, new properties.

For `openminds.internal.*`, nothing is promised. It may change in a patch
release.

Two things sit outside this promise because they track an external source:

- **Generated metadata types** follow the openMINDS metadata model. When the
  model changes a type, the toolbox follows it. Version selection
  (`openminds.selectModelVersion`) is how a user pins this.
- **`openminds.enum.Types` and `openminds.enum.Modules`** are generated from
  the model for the same reason.

## The public surface

### Core

| Name | Role |
|---|---|
| `openminds.<module>.<Type>` | The generated metadata types |
| `openminds.Node` | Base class of every metadata type |
| `openminds.Collection` | A linked graph of nodes, saved and loaded as JSON-LD |
| `openminds.fromTypeName` | Blank instance from a type name or IRI |
| `openminds.instanceFromIRI` | Controlled-term instance from its IRI |
| `openminds.enum.Types`, `openminds.enum.Modules` | Enumerations of the active model |

### Toolbox and model version

`openminds.startup`, `openminds.selectModelVersion`, `openminds.getModelVersion`,
`openminds.version`, `openminds.toolboxdir`, `openminds.toolboxversion`,
`openminds.getpref`, `openminds.setpref`, and the top-level `code/setup.m`.

### Extension points

For projects building on the toolbox rather than only consuming it.

| Name | Role |
|---|---|
| `openminds.interface.MetadataStore` | Contract for a backing store |
| `openminds.interface.LinkResolver` | Contract for resolving external links |
| `openminds.registerLinkResolver` | Register a resolver |
| `openminds.base.*` | Base classes to subclass: `Visitor`, `Serializer`, `Deserializer`, `Transformer`, `MixedTypeSet`, `ControlledTerm` |

### Helpers

`openminds.utility.*` (predicates and name parsing), `openminds.constant.*`,
`openminds.mustBeOpenMINDSIRI`, `openminds.mustBeValidModelVersion`, and the
unpackaged validators in `code/validators`.

## The internal surface

`openminds.internal.*`. It holds the serializer and deserializer
implementations, the resolver registry, type metadata, the vocabulary, the
metadata stores, the graph and display machinery, string and file utilities,
and the schema generator.

The generator and the download helpers are internal *and* are not needed at
runtime by a user. They currently ship inside the toolbox; moving them out is
tracked separately.

## What real consumers actually use

Two projects build on this toolbox. Both were surveyed on 2026-09-04. They are
the evidence for every gap listed in the next section, and neither should have
to reach into `openminds.internal` to do its job.

**`openminds-kg-sync`** implements `interface.MetadataStore` and
`interface.LinkResolver`, and subclasses the JSON-LD serializer. It is current
with v0.10.0.

**`openMINDS-MATLAB-GUI`** subclasses `Collection` and drives a property editor
from type introspection. It is written against a pre-`Node` toolbox and much of
what it references no longer exists, so treat its usage as a statement of need
rather than a working dependency.

## Gaps: internal names that consumers depend on

Each of these is a place where the boundary above is not yet honest. Ordered by
how much it matters.

**1. Type introspection has no public equivalent.** Both consumers use
`openminds.internal.meta.Type` — the GUI to decide whether a property renders
as a dropdown, a list, or a type picker; kg-sync to walk a downloaded graph.
Its public method set is already shaped like an API:
`isPropertyValueScalar`, `isPropertyWithLinkedType`, `isPropertyWithEmbeddedType`,
`isPropertyMixedType`, `getMixedTypeForProperty`, `listLinkedTypesForProperty`,
`listEmbeddedTypesForProperty`, plus `NumProperties` and `PropertyNames`.
*Recommendation: promote it.* Naming needs a decision — `openminds.TypeInfo` as
a single top-level class avoids a `+meta` subpackage, which inside `+openminds`
would shadow MATLAB's own `meta` package for code in this toolbox.

**2. `Node` hides members that extenders must call.** `isReference()`,
`getLinkedInstances()`, `getEmbeddedInstances()` and the `id` property are all
`Hidden`, and kg-sync calls every one of them from its store implementation.
`isReference()` is the canonical predicate as of the merged decision to keep
references as references, so hiding it contradicts its own documentation.
*Recommendation: make `isReference()`, `getTypeName()` and reading `id` public.
Decide whether store implementers get a public traversal API or whether
`getLinkedInstances`/`getEmbeddedInstances` simply become public.*
Related: kg-sync has a blocked TODO because a store cannot write back an
identifier — `id` is `SetAccess = protected` with no public path for a store.

**3. The `LinkResolver` contract leaks an internal type.** A resolver is handed
an instance that may be an `openminds.internal.MixedTypeReference`, and kg-sync
must test for it by class name to know whether the target type is known. A
public interface cannot require an internal name to implement.
*Recommendation: promote it to `openminds.base.MixedTypeReference`, or add a
public predicate that answers the same question.*

**4. Instance events carry an internal payload.** `Node` declares
`InstanceChanged` and `PropertyWithLinkedInstanceChanged`. Nothing in the
toolbox or its tests listens to either, which is why they had been marked
`% Todo: Remove??`; the GUI listens to both to keep its graph view live. The
TODO is now gone and both events are documented in place. What remains is that
a listener receives an
`openminds.internal.event.PropertyValueChangedEventData` — a public event
delivering an internal type. *Recommendation: promote the event data class, or
document its four properties as the stable payload contract.*

**5. `Collection` is subclassed but has no subclassing contract.** The GUI
extends it, overrides the protected `addNode`, relies on a protected
`onNodesSet` hook, and reads the `Hidden` `TypeMap`. One of its own comments
admits it is misusing `addNode` for want of a public way to update node links.
*Recommendation: decide whether `Collection` is officially extensible. If yes,
document the protected surface and add the missing link-update method. If no,
seal it and offer an observer instead.* This is the largest open design
question on the list.

**6. Serializer subclassing goes through an internal class.** kg-sync extends
`openminds.internal.serializer.JsonLdSerializer` and overrides its protected
post-processing hook. `openminds.base.Serializer` is already public, so the
extension point exists but the useful concrete class does not.
*Recommendation: make the JSON-LD serializer public, or document the base class
hook as the supported way and ensure it is sufficient.*

**7. Type name, label and IRI conversion.** The GUI calls internal name helpers
at roughly thirty sites. `openminds.enum.Types` already covers class name to
type name in both directions, which likely removes most of them, but IRI to
class name and type name to human label have no public form.
*Recommendation: add the two missing conversions to `openminds.utility`, and
document that `enum.Types` is the answer for the rest.*

**8. Reading a class constant needs `eval`.** To list a controlled term's
allowed instances or a mixed type's allowed types, the GUI evaluates a string
because MATLAB cannot read a constant off a class name directly. The toolbox
does the same thing internally. `openminds.internal.listControlledInstances`
exists but is not public.
*Recommendation: promote it and add the mixed-type equivalent.*

**9. `openminds.utility.isEmbeddedType` was removed while in use.** It was
deleted as dead code, but `openminds.utility` is declared as the namespace
"useful for external developers" and the GUI calls it at two sites. Whether or
not the GUI is current, this is a public name removed without a shim.
*Recommendation: restore it, or provide the equivalent through the
introspection API of gap 1 and deprecate the old name properly.*

**10. Label access is inconsistent.** `getDisplayLabel()` is `protected`, yet
the GUI calls it from outside the class hierarchy, and also reads a
`DisplayString` property that no longer exists.
*Recommendation: settle on one public way to get an instance's display label
and document it.*

## Open decisions

These need a call before the gaps above can be implemented.

1. The public name for type introspection, and whether it is a class or a
   package.
2. Whether `Collection` is officially subclassable, and if so what its protected
   contract is.
3. Whether store implementers traverse the graph through public `Node` methods
   or through a separate visitor-shaped API.
4. Whether v1.0.0 ships deprecation shims for the names the rename series
   changed, or declares itself the clean break. No shims exist today except
   `Node.isUnresolved`.
