# Public API surface

What this toolbox promises to keep stable, and what it reserves the right to
change. Written ahead of v1.0.0, when those promises start binding.

## The rule

**A name is internal if any segment of its package path is `internal`.
Every other name under `openminds` is public.**

The segment may sit at any depth. `openminds.internal.serializer.JsonLdSerializer`
is internal, and so would be `openminds.graph.internal.Walker` if it existed.
A subsystem can keep a private corner without inventing a second convention,
and the test stays something you can apply by reading a call, with no list to
consult.

There is one exception, called out because it cannot be expressed in a package
name: the unpackaged property validators in `code/validators` are public,
because generated type classes reference them unqualified in `arguments` blocks
and user-facing validation errors name them.

Folder layout follows the rule rather than defining it. Everything ships from
`code/+openminds`, so the package path is the only boundary a reader has to
learn.

One corollary, since inheritance carries members across the line: **a public
class must not inherit public or protected members from an internal class.**
Four do today; see gap 11.

### The rule is not true yet: generated mixed types

The 1520 generated mixed-type classes are emitted into
`openminds.internal.mixedtype`, six model versions' worth. The rule therefore
calls every one of them internal, and they are not internal in any sense a user
would recognise:

- `class(subject.species)` returns
  `openminds.internal.mixedtype.subject.Species` for any "one of" property that
  has not been assigned yet.
- `getMixedTypeForProperty` returns the same names, and that method is part of
  the introspection API that is now to become public.
- The GUI constructs them by name.

Assignment errors do not leak the name — they list the allowed public types —
so the exposure is narrower than it first looks, but it is real.

Either the classes move to `openminds.mixedtype`, or the rule acquires a second
exception. *Recommendation: move them.* A rule with an exception per accident
stops being a rule, these classes are part of the model's surface rather than
an implementation detail, and v1.0.0 is the moment to pay for it. The move is
mechanical and shaped like the `Node` rename: 1520 generated files, one
generator emission site, and four hand-written references that name the full
prefix in `Node.m` and `internal/meta/Type.m`. Checks written as
`contains(name, 'mixedtype')` keep working, since the `mixedtype` segment
survives.

## Stability promise from v1.0.0

For public names, within a major version:

- A name is not removed or renamed without a deprecation shim that warns once
  per session and keeps working for at least one minor release.
- A function does not lose an input or output, and does not change the meaning
  of one.
- A class does not remove or rename a public property, method, or event.
- For a class declared extensible below, the same holds for its **protected**
  members. A subclass that overrides a protected method depends on its name and
  signature exactly as a caller depends on a public one, and "not sealed" is
  otherwise an accident rather than a promise.
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
| `openminds.meta.Type` | Describes a type's properties: scalar, linked, embedded, mixed |
| `openminds.meta.fromInstance`, `openminds.meta.fromClassName` | Cached lookup of the above |

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

**1. Type introspection.** *Done.* `openminds.internal.meta.Type` is now
`openminds.meta.Type`, with `fromInstance` and `fromClassName` alongside it.
The two lookups came too because they are the cached path, not sugar: the
constructor builds a fresh object each call, while they return one shared
object per type, and the public `openminds.base.Serializer` already used
`fromInstance` on every node it wrote. `MetaTypeRegistry` stayed behind as
`openminds.internal.meta.MetaTypeRegistry`, since it is the cache rather than
the interface to it.

Still coupled to the mixed-type question above: `getMixedTypeForProperty`
returns `openminds.internal.mixedtype.*` class names, so a public method
returns internal names until those classes move.

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

**3. The `LinkResolver` contract leaks an internal type.** This is a different
problem from gap 6 below, though the two share a shape. Here the *interface*
itself is the issue. Its own help text sets out a distinction every implementer
must act on: a reference whose type is known can be populated in place, while
one whose type is not known until it is probed must be replaced, because an
instance cannot change its class. The interface then offers no public way to
tell the two apart, so kg-sync tests
`isa(instance, 'openminds.internal.MixedTypeReference')`. An interface that
documents a fork and hides the switch is incomplete.
*Recommendation: promote `MixedTypeReference` to `openminds.base`, or add a
public predicate that answers the same question.* While there, note that the
interface's help text names `openminds.internal.resolver.ResolvingVisitor`
twice, once in a `See also` — public documentation pointing at internal
classes.

**4. Instance events carry an internal payload.** `Node` declares
`InstanceChanged` and `PropertyWithLinkedInstanceChanged`. Nothing in the
toolbox or its tests listens to either, which is why they had been marked
`% Todo: Remove??`; the GUI listens to both to keep its graph view live. The
TODO is now gone and both events are documented in place. What remains is that
a listener receives an
`openminds.internal.event.PropertyValueChangedEventData` — a public event
delivering an internal type. *Recommendation: promote the event data class, or
document its four properties as the stable payload contract.*

**5. `Collection` is extensible in fact but not in promise.** Nothing stops the
GUI subclassing it: `Collection` is not sealed, so MATLAB lets a subclass
override any protected method, and the GUI overrides `addNode`. The gap is not
capability, it is coverage. The stability promise above would otherwise reach
only public members, leaving `addNode`'s name and its name-value options free to
change under a subclass that depends on them exactly as a caller depends on a
public method.

**Decided: `Collection` is extensible**, and the promise now extends to the
protected members of classes declared so. What remains is to declare which
classes those are and to write down the protected surface: `addNode`,
`addSubNodes` and `getBlankNodeIdentifier`, plus read access to `Nodes` and the
`Hidden` `TypeMap` that the GUI writes.

Two findings from checking this. The GUI overrides `onNodesSet`, which exists
nowhere in the toolbox — so that override is dead code and whatever the GUI
expected on node changes is not happening. And a GUI comment admits it is
misusing `addNode` for want of a public way to update node links, which is a
missing method rather than a visibility question.

**6. Serializer subclassing goes through an internal class.** kg-sync extends
`openminds.internal.serializer.JsonLdSerializer` and overrides its protected
post-processing hook to emit a KG-flavoured document. `openminds.base.Serializer`
is already public, so the extension point exists but the concrete class worth
extending does not.

**Decided: the JSON-LD serializer becomes public.** Subclassing the concrete
serializer is the right way to vary one step of a format, and rebuilding
JSON-LD from the abstract base to change a post-processing step would be
absurd. Promotion brings its constructor name-value arguments and its
protected hook into the promise, so both want documenting as part of the move.
Note the hook was renamed to `postProcessDocuments` by the IRI branch, which
breaks kg-sync's override; see the clean-break note below.

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
the GUI calls it from outside the class hierarchy. `DisplayString`, which the
GUI also reads, does exist and is public — an earlier note here said otherwise
and was wrong. It is inherited from an internal mixin; see gap 11.
*Recommendation: document `string(instance)` as the one public way to get a
display label, since it is already public and already returns it.*

**11. Public classes inherit from internal ones.** Four do, and one of them is
`Node`:

| Public class | Internal superclass |
|---|---|
| `openminds.Node` | `internal.mixin.StructAdapter`, `internal.mixin.CustomInstanceDisplay` |
| `openminds.base.Visitor` | `internal.graph.TraversalCore` |
| `openminds.base.Transformer` (and `Serializer` through it) | `internal.graph.TraversalCore` |
| `openminds.base.MixedTypeSet` | `internal.mixin.CustomInstanceDisplay` |

This is not cosmetic, because those superclasses declare members that are
public or protected on the subclass. `CustomInstanceDisplay` is where
`DisplayString`, `char` and `string` come from, so the display API of every
metadata type in the toolbox is declared in an internal class.
`TraversalCore` contributes a public `reset` and eight protected traversal
helpers — `getLinkedEdges`, `getEmbeddedEdges`, `setEdgeChildren`,
`wasVisited`, `markVisited`, `visitedNode`, `unmarkVisited` and the static
`nodeKey` — and the toolbox's own `ResolvingVisitor` calls `nodeKey`, so that
surface is real rather than theoretical. Both internal classes also declare
abstract members a subclass must implement, which puts the instructions for
writing a public subclass inside `openminds.internal`.

It does not break anyone's code: a subclass author writes
`< openminds.base.Visitor` and never names the superclass. But it is
observable through `superclasses` and `meta.class`, which the GUI already uses
for type checks elsewhere, and it contradicts the promise above now that the
promise covers protected members of extensible classes.

*Recommendation: move these superclasses into `openminds.base`.* Each is
abstract and meaningful only as a superclass, which is exactly why
`ControlledTermBase` already sits in `base`. Alternatively fold each into its
single public subclass, though `TraversalCore` has two and would be
duplicated.

## Decisions

Settled 2026-09-04.

1. **Type introspection is public.** Recommended as `openminds.meta.Type`, the
   existing name minus the `internal` segment; see gap 1.
2. **`Collection` is extensible**, and the stability promise covers the
   protected members of classes declared extensible. See gap 5.
3. **The JSON-LD serializer is public.** Gap 3 is a separate problem about the
   `LinkResolver` contract and needs its own fix. See gaps 3 and 6.
4. **v1.0.0 is the clean break.** No deprecation shims for anything the rename
   series changed. The promise starts at 1.0 and binds from there.

### What the clean break commits us to

The shims stop being a question, but the communication does not. Nothing warns
a consumer that a name moved, so the release notes carry the whole burden, and
the substitution list has to be complete. Both surveyed projects will hit it:
kg-sync on `getUnresolvedLinks` becoming `getUnresolvedLinkIdentifiers` and
`postProcessInstances` becoming `postProcessDocuments`, the GUI on most of the
internal names it uses.

It also settles a smaller question by implication. `Node.isUnresolved` is the
one deprecation shim in the toolbox, warning once per session and forwarding to
`isReference`. A clean break at 1.0 is the moment to delete it rather than
carry it into a version whose whole point is that the names are now fixed.

## Still open

- Placement of the introspection class, if `openminds.meta.Type` is not right.
- Whether generated mixed types move to `openminds.mixedtype`, or the rule
  takes a second exception. Coupled to gap 1: promoting introspection without
  this ships a public method that returns internal class names.
- Whether store implementers traverse the graph through public `Node` methods
  or a separate visitor-shaped API. This is gap 2 and is untouched by the four
  decisions above.
